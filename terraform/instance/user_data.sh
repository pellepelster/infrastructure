#!/usr/bin/env bash

set -o pipefail -o errexit -o nounset

CADDY_VERSION="2.5.2"
CADDY_CHECKSUM="641908bbf6f13ee69f3c445a44012d0c3327462c00a1d47fb40f07ce5d00e31b"

${user_data_lib}

function packages_update {
    DEBIAN_FRONTEND=noninteractive apt-get update
}

function system_update {
    DEBIAN_FRONTEND=noninteractive apt-get \
        -o Dpkg::Options::="--force-confnew" \
        --assume-yes \
        -fuy \
        dist-upgrade

  if [[ -f /var/run/reboot-required ]]; then
    shutdown -r now
  fi
}

function install_prerequisites {
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -qq -y \
    ufw \
    uuid
}

function ufw_setup {
  ufw enable
  ufw allow ssh
  ufw allow http
  ufw allow https
}

function sshd_config {
cat <<-EOF

HostKey /etc/ssh/ssh_host_ed25519_key

LoginGraceTime 2m
PermitRootLogin yes

PasswordAuthentication no
PubkeyAuthentication yes
PermitEmptyPasswords no

ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding no
PrintMotd no

AcceptEnv LANG LC_*

Subsystem	sftp	/usr/lib/openssh/sftp-server

AuthorizedKeysFile /etc/ssh/authorized_keys/%u .ssh/authorized_keys

Match User deploy
  ChrootDirectory %h
  ForceCommand internal-sftp
  AllowTcpForwarding no
  X11Forwarding no
  PasswordAuthentication no
EOF
}

function deploy_user_setup() {
  useradd  -s /usr/bin/nologin -d /storage/www/html/ deploy
  PASSWORD=$(uuid)
  echo -e "$${PASSWORD}\n$${PASSWORD}" | passwd deploy

  mkdir /etc/ssh/authorized_keys
  chown root:root /etc/ssh/authorized_keys
  chmod 755 /etc/ssh/authorized_keys

  echo "${deploy_public_key}" | base64 -d > /etc/ssh/authorized_keys/deploy
  chmod 644 /etc/ssh/authorized_keys/deploy
}

function sshd_setup() {
  touch /etc/ssh/ssh_host_ed25519_key.pub
  chmod 600 /etc/ssh/ssh_host_ed25519_key.pub

  echo "${ssh_identity_ed25519_key}" | base64 -d > /etc/ssh/ssh_host_ed25519_key
  echo "${ssh_identity_ed25519_pub}" | base64 -d > /etc/ssh/ssh_host_ed25519_key.pub

  sshd_config > /etc/ssh/sshd_config
  service ssh restart
}

function www_systemd_config() {
  cat <<-EOF
[Unit]
Description=www
Requires=network-online.target
After=network-online.target

[Service]
Restart=always
RestartSec=5
ExecStart=/usr/local/bin/caddy run --config /etc/Caddyfile
ExecReload=/bin/kill -HUP \$MAINPID

[Install]
WantedBy=multi-user.target
EOF
}

function www_template() {
  cat <<EOF
{
    storage file_system /storage/www/data/
}

pelle.io, pellepelster.de, krawallbude.de, krawallbu.de {
  log {
    output file /storage/www/logs/pelle.io {
      roll_uncompressed
      roll_keep     10000
      roll_keep_for 87600h
    }

    format console
    level  INFO
  }

	root * /storage/www/html
	file_server
}

solidblocks.de, blcks.de  {

  log {
    output file /storage/www/logs/solidblocks.de {
      roll_uncompressed
      roll_keep     10000
      roll_keep_for 87600h
    }

    format console
    level  INFO
  }

  redir https://pellepelster.github.io/solidblocks/
}
EOF
}

function www_setup() {
  mkdir -p /storage/www/logs
  mkdir -p /storage/www/data
  mkdir -p /storage/www/html

  www_template > /etc/Caddyfile
  www_systemd_config >/etc/systemd/system/www.service
  systemctl daemon-reload
  systemctl enable www
  systemctl restart www
}

function caddy_install() {
  curl -L "https://github.com/caddyserver/caddy/releases/download/v$CADDY_VERSION/caddy_$${CADDY_VERSION}_linux_amd64.tar.gz" -o /tmp/caddy.tar.gz
  echo "$CADDY_CHECKSUM  /tmp/caddy.tar.gz" | sha256sum -c
  tar -xvf /tmp/caddy.tar.gz caddy
  rm -f /tmp/caddy.tar.gz
  chmod +x caddy
  mv caddy /usr/local/bin/
}

mount_volume "${storage_device}" "/storage"
floating_ip_attach "${floating_ip}"

sshd_setup
packages_update

install_prerequisites

ufw_setup

deploy_user_setup

caddy_install
www_setup

system_update