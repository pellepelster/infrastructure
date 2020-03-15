#!/usr/bin/env bash

set -eu

DIR="$( cd "$(dirname "$0")" ; pwd -P )"

function task_deploy {
  ansible-playbook --extra-vars="fde_password=$(pass marvin/fde_password)" -i "${DIR}/production" "${DIR}/site.yml"
}

function task_usage {
  echo "Usage: $0 ..."
  exit 1
}

arg=${1:-}
shift || true
case ${arg} in
  deploy) task_deploy "$@" ;;
  *) task_usage ;;
esac