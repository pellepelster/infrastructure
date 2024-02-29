DEBIAN_FRONTEND=noninteractive

function mount_volume() {
  local device="${1:-}"
  local mount_point="${2:-}"

  mkdir -p "${mount_point}"
  echo "${device}  ${mount_point}  ext4 discard,nofail,defaults 0 0" >> /etc/fstab

  while ! mount "${mount_point}"; do
    echo "mounting '${mount_point}'"
  done
}