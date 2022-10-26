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


function floating_ip_config() {
  local floating_ip="${1:-}"
  cat <<EOF
 auto eth0:1
 iface eth0:1 inet static
     address ${floating_ip}
     netmask 32
EOF
}

function floating_ip_attach() {
  local floating_ip="${1:-}"
  floating_ip_config "${floating_ip}" > /etc/network/interfaces.d/60-floating-ip.cfg
  service networking restart
}