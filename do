#!/usr/bin/env bash

set -o pipefail -o errexit -o nounset

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

DOMAIN="pelle.io"

trap task_clean EXIT

TEMP_DIR="${DIR}/.tmp.$$"
mkdir -p "${TEMP_DIR}"

SOLIDBLOCKS_SHELL_VERSION="v0.2.5"
SOLIDBLOCKS_SHELL_CHECKSUM="d07eb3250f83ae545236fdd915feca602bdb9b683140f2db8782eab29c9b2c48"

# self contained function for initial Solidblocks bootstrapping
function bootstrap_solidblocks() {
  local default_dir="$(cd "$(dirname "$0")" ; pwd -P)"
  local install_dir="${1:-${default_dir}/.solidblocks-shell}"

  local temp_file="$(mktemp)"

  curl -v -L "${SOLIDBLOCKS_BASE_URL:-https://github.com}/pellepelster/solidblocks/releases/download/${SOLIDBLOCKS_SHELL_VERSION}/solidblocks-shell-${SOLIDBLOCKS_SHELL_VERSION}.zip" > "${temp_file}"
  echo "${SOLIDBLOCKS_SHELL_CHECKSUM}  ${temp_file}" | sha256sum -c

  mkdir -p "${install_dir}" || true
  (
      cd "${install_dir}"
      unzip -o -j "${temp_file}" -d "${install_dir}"
      rm -f "${temp_file}"
  )
}


function ensure_environment() {

  if [[ ! -d "${DIR}/.solidblocks-shell" ]]; then
    echo "environment is not bootstrapped, please run ./do bootstrap first"
    exit 1
  fi

  source "${DIR}/.solidblocks-shell/log.sh"
  source "${DIR}/.solidblocks-shell/utils.sh"
  source "${DIR}/.solidblocks-shell/pass.sh"
  source "${DIR}/.solidblocks-shell/text.sh"
  source "${DIR}/.solidblocks-shell/software.sh"

  software_set_export_path
}

function task_bootstrap() {
  bootstrap_solidblocks
  ensure_environment
  ensure_command "pass"
  ensure_command "docker"
  software_ensure_terraform
}

function task_clean {
  rm -rf "${TEMP_DIR}"
}

function task_usage {
  echo "Usage: $0 build | test | deploy"
  exit 1
}

function terraform_wrapper_do() {
  local directory=${1:-}
  local command=${2:-apply}
  shift || true
  shift || true

  terraform_wrapper "${directory}" init -upgrade -lock=false
  terraform_wrapper "${directory}" "${command}" -lock=false "$@"
}

function terraform_wrapper() {
  local directory=${1:-}
  shift || true
  (
      cd "${DIR}/${directory}"
      terraform "$@"
  )
}

function task_infra_instance {
  export TF_VAR_domain="${DOMAIN}"
  export TF_VAR_hostname="www"
  export TF_VAR_cloud_api_token="$(pass "infrastructure/${DOMAIN}/cloud_api_token")"
  export TF_VAR_dns_api_token="$(pass "infrastructure/${DOMAIN}/dns_api_token")"

  terraform_wrapper_do "terraform/instance" "$@"
}

function task_infra_storage {
  export TF_VAR_hostname="www"
  export TF_VAR_cloud_api_token="$(pass "infrastructure/${DOMAIN}/cloud_api_token")"

  terraform_wrapper_do "terraform/storage" "$@"
}

function task_www_report {
  local public_ipv4="$(terraform_wrapper "terraform/instance" "output" "-json" | jq -r '.public_ipv4.value')"
  local reports_dir="${DIR}/reports"

  mkdir -p "${reports_dir}"
  scp -o UserKnownHostsFile=${DIR}/ssh_known_hosts -r "root@${public_ipv4}:/storage/www/logs/*" "${reports_dir}"
  goaccess --agent-list --output html --log-format CADDY ${reports_dir}/* > "${DIR}/report.html"
  xdg-open "${DIR}/report.html"
}

function task_ssh_instance {
  local public_ipv4="$(terraform_wrapper "terraform/instance" "output" "-json" | jq -r '.public_ipv4.value')"
  ssh -o UserKnownHostsFile=${DIR}/ssh_known_hosts root@${public_ipv4} "$@"
}

function task_output {
  terraform_wrapper "terraform/instance" "output" "-json" | jq "$@"
}

function task_deploy_html {
  local dir=${1:-}

  pass "infrastructure/${DOMAIN}/deploy_ssh_key" > "${TEMP_DIR}/deploy_ssh"
  chmod 600 "${TEMP_DIR}/deploy_ssh"

  echo "put -R ${dir}/*" > "${TEMP_DIR}/deploy_batch"
  echo "exit" >> "${TEMP_DIR}/deploy_batch"
  #sftp -b "${TEMP_DIR}/deploy_batch" -i "${TEMP_DIR}/deploy_ssh" deploy@pelle.io
  sftp -i "${TEMP_DIR}/deploy_ssh" deploy@pelle.io
}

function task_set_cloud_api_token {
  echo "Enter the Hetzner Cloud API token, followed by [ENTER]:"
  read -r hetzner_cloud_api_token
  echo ${hetzner_cloud_api_token} | pass insert -m "infrastructure/${DOMAIN}/cloud_api_token"
}

function task_set_dns_api_token {
  echo "Enter the Hetzner DNS API token, followed by [ENTER]:"
  read -r hetzner_dns_api_token
  echo ${hetzner_dns_api_token} | pass insert -m "infrastructure/${DOMAIN}/dns_api_token"
}

ARG=${1:-}
shift || true

case "${ARG}" in
  bootstrap) ;;
  *) ensure_environment ;;
esac

case ${ARG} in
  bootstrap) task_bootstrap "$@" ;;

  deploy-html) task_deploy_html "$@" ;;

  output) task_output "$@" ;;

  www-report) task_www_report "$@" ;;

  infra-storage) task_infra_storage "$@" ;;
  infra-instance) task_infra_instance "$@" ;;

  ssh-instance) task_ssh_instance "$@" ;;

  set-cloud-api-token) task_set_cloud_api_token ;;
  set-dns-api-token) task_set_dns_api_token ;;

  *) task_usage ;;
esac
