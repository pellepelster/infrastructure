#!/usr/bin/env bash

set -o pipefail -o errexit -o nounset

export DEBIAN_FRONTEND=noninteractive

${user_data_lib}

function docker_login {
  echo "${github_token}" | docker login https://docker.pkg.github.com -u ${github_owner} --password-stdin
}

function packages_update {
    apt-get update

    #apt-get \
    #    -o Dpkg::Options::="--force-confnew" \
    #    --force-yes \
    #    -fuy \
    #    dist-upgrade
}

function install_prerequisites {
  apt-get install --no-install-recommends -qq -y \
    docker.io \
    docker-compose \
    gnupg2 \
    pass \
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

function docker_systemd_config {
cat <<-EOF
[Unit]
Description=%i service with docker compose
Requires=docker.service
After=docker.service

[Service]
Restart=always
TimeoutStartSec=1200

WorkingDirectory=/opt/dockerfiles/%i

# Remove old containers, images and volumes and update it
ExecStartPre=/usr/bin/docker-compose down -v
ExecStartPre=/usr/bin/docker-compose rm -fv
ExecStartPre=/usr/bin/docker-compose pull

# Compose up
ExecStart=/usr/bin/docker-compose up

# Compose down, remove containers and volumes
ExecStop=/usr/bin/docker-compose down -v

[Install]
WantedBy=multi-user.target
EOF
}

function deploy_user_setup() {
  useradd  -s /usr/bin/nologin -d /storage/www/data/ deploy
  PASSWORD=$(uuid)
  echo -e "$${PASSWORD}\n$${PASSWORD}" | passwd deploy

  mkdir /etc/ssh/authorized_keys
  chown root:root /etc/ssh/authorized_keys
  chmod 755 /etc/ssh/authorized_keys

  echo "${deploy_public_key}" | base64 -d > /etc/ssh/authorized_keys/deploy
  chmod 644 /etc/ssh/authorized_keys/deploy
}


function docker_compose_config {
cat <<-EOF
version: "3"
services:
  www:
    image: docker.pkg.github.com/pellepelster/pelle.io-infrastructure/www:latest
    environment:
      - "HOSTNAME=${hostname}"
    ports:
      - "443:443"
      - "80:80"
    volumes:
      - "/storage/www:/storage"
EOF
}

function sshd_setup() {
  touch /etc/ssh/ssh_host_ed25519_key.pub
  chmod 600 /etc/ssh/ssh_host_ed25519_key.pub

  echo "${ssh_identity_ed25519_key}" | base64 -d > /etc/ssh/ssh_host_ed25519_key
  echo "${ssh_identity_ed25519_pub}" | base64 -d > /etc/ssh/ssh_host_ed25519_key.pub

  sshd_config > /etc/ssh/sshd_config
  service ssh restart
}

mount_volume "${storage_device}" "/storage"
floating_ip_attach "${floating_ip}"

sshd_setup
packages_update

install_prerequisites

ufw_setup
docker_login

docker_systemd_config > /etc/systemd/system/docker-compose@.service
mkdir -p /opt/dockerfiles/www
docker_compose_config > /opt/dockerfiles/www/docker-compose.yml

mkdir -p /storage/www/ssl/default
mkdir -p /storage/www/logs
mkdir -p /storage/www/data/www

deploy_user_setup

echo "${certificate}" | base64 -d > /storage/www/ssl/default/certificate.pem
echo "${private_key}" | base64 -d > /storage/www/ssl/default/private_key.pem

systemctl daemon-reload
systemctl enable docker-compose@www
systemctl start docker-compose@www
