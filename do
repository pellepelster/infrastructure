#!/usr/bin/env bash

set -o pipefail -o errexit -o nounset
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

DOMAIN="pelle.io"

trap task_clean SIGINT SIGTERM ERR EXIT

TEMP_DIR="${DIR}/.tmp.$$"
mkdir -p "${TEMP_DIR}"

###############################################################################
# bootstrapping
###############################################################################
function bootstrap_solidblocks() {
  local dir="${1:-}"

  SOLIDBLOCKS_SHELL_VERSION="v0.0.41"
  SOLIDBLOCKS_SHELL_CHECKSUM="7c5cb9a80649a1eb9927ec96820f9d0c5d09afa3f25f6a0f8745b99dcbf931b7"

  if [[ ! -d "${dir}" ]]; then
    curl -L "https://github.com/pellepelster/solidblocks/releases/download/${SOLIDBLOCKS_SHELL_VERSION}/solidblocks-shell-${SOLIDBLOCKS_SHELL_VERSION}.zip" >"solidblocks-shell-${SOLIDBLOCKS_SHELL_VERSION}.zip"
    echo "${SOLIDBLOCKS_SHELL_CHECKSUM}  solidblocks-shell-${SOLIDBLOCKS_SHELL_VERSION}.zip" | sha256sum -c
    unzip -o "solidblocks-shell-${SOLIDBLOCKS_SHELL_VERSION}.zip"
    rm -f "solidblocks-shell-${SOLIDBLOCKS_SHELL_VERSION}.zip"
  fi
}

function ensure_environment() {
  source "${DIR}/solidblocks-shell/log.sh"
  source "${DIR}/solidblocks-shell/utils.sh"
  source "${DIR}/solidblocks-shell/software.sh"

  software_set_export_path
}

function task_bootstrap() {
  bootstrap_solidblocks "${DIR}/solidblocks-shell"
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

  if [ ! -d "${directory}/.terraform" ]; then
    terraform_wrapper "${directory}" init -lock=false
  fi

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

function task_ssh_instance {
  local public_ip="$(terraform_wrapper "terraform/instance" "output" "-json" | jq -r '.public_ip.value')"
  ssh -o UserKnownHostsFile=${DIR}/ssh_known_hosts root@${public_ip} "$@"
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

  infra-instance) task_infra_instance "$@" ;;
  infra-storage) task_infra_storage "$@" ;;

  ssh-instance) task_ssh_instance "$@" ;;
  set-cloud-api-token) task_set_cloud_api_token ;;
  set-dns-api-token) task_set_dns_api_token ;;
  *) task_usage ;;
esac
