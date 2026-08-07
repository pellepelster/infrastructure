locals {
  ssh_dir = abspath("${path.module}/../../.ssh")
}

resource "tls_private_key" "www_public" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "www_public" {
  name       = "www-public"
  public_key = tls_private_key.www_public.public_key_openssh
}

resource "tls_private_key" "www_public_host" {
  algorithm = "ED25519"
}

resource "hcloud_primary_ip" "www_public_ipv4" {
  name              = "www-public-ipv4"
  type              = "ipv4"
  location          = var.location
  auto_delete       = false
  delete_protection = true
}

resource "hcloud_primary_ip" "www_public_ipv6" {
  name              = "www-public-ipv6"
  type              = "ipv6"
  location          = var.location
  auto_delete       = false
  delete_protection = true
}

resource "hcloud_rdns" "www_public_ipv4" {
  primary_ip_id = hcloud_primary_ip.www_public_ipv4.id
  ip_address    = hcloud_primary_ip.www_public_ipv4.ip_address
  dns_ptr       = "pelle.io"
}

resource "hcloud_rdns" "www_public_ipv6" {
  primary_ip_id = hcloud_primary_ip.www_public_ipv6.id
  ip_address    = local.zone_ipv6
  dns_ptr       = "pelle.io"
}

resource "hcloud_server" "www_public" {
  name        = "www-public"
  image       = "debian-13"
  server_type = "cx23"
  location    = var.location

  user_data = <<-EOT
    #cloud-config
    ssh_keys:
      ed25519_private: |
        ${indent(4, tls_private_key.www_public_host.private_key_openssh)}
      ed25519_public: ${trimspace(tls_private_key.www_public_host.public_key_openssh)}
  EOT

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.www_public_ipv4.id
    ipv6_enabled = true
    ipv6         = hcloud_primary_ip.www_public_ipv6.id
  }

  ssh_keys = [
    hcloud_ssh_key.www_public.id
  ]
}

resource "local_sensitive_file" "www_public_ssh_key" {
  filename             = "${local.ssh_dir}/www-public.ed25519.key"
  content              = tls_private_key.www_public.private_key_openssh
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "www_public_ssh_public_key" {
  filename             = "${local.ssh_dir}/www-public.ed25519.key.pub"
  content              = tls_private_key.www_public.public_key_openssh
  file_permission      = "0644"
  directory_permission = "0700"
}

resource "local_file" "known_hosts" {
  filename             = "${local.ssh_dir}/known_hosts"
  file_permission      = "0644"
  directory_permission = "0700"
  content              = <<-EOT
    ${hcloud_server.www_public.ipv4_address} ${trimspace(tls_private_key.www_public_host.public_key_openssh)}
    ${local.zone_ipv6} ${trimspace(tls_private_key.www_public_host.public_key_openssh)}
  EOT
}

resource "local_file" "ssh_config" {
  filename             = "${local.ssh_dir}/config"
  file_permission      = "0600"
  directory_permission = "0700"
  content              = <<-EOT
    Host ${hcloud_server.www_public.name}
      HostName ${hcloud_server.www_public.ipv4_address}
      User root
      IdentityFile ${local.ssh_dir}/www-public.ed25519.key
      IdentitiesOnly yes
      UserKnownHostsFile ${local_file.known_hosts.filename}
      StrictHostKeyChecking yes
  EOT
}
