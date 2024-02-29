resource "hcloud_primary_ip" "www_ipv4" {
  name          = "www-ipv4"
  type          = "ipv4"
  assignee_type = "server"
  datacenter    = var.datacenter
  auto_delete   = false
  labels = {
    "type" : "www"
  }
  delete_protection = true
}

resource "hcloud_primary_ip" "www_ipv6" {
  name          = "www-ipv6"
  type          = "ipv6"
  assignee_type = "server"
  datacenter    = var.datacenter
  auto_delete   = false
  labels = {
    "type" : "www"
  }
  delete_protection = true
}

resource "hcloud_server" "www" {
  name        = "www"
  image       = "debian-12"
  server_type = "cx11"
  location    = var.location
  user_data   = data.template_file.user_data.rendered

  labels = {
    type = "www"
  }

  ssh_keys = [
    hcloud_ssh_key.pelle.id
  ]

  public_net {
    ipv4 = hcloud_primary_ip.www_ipv4.id
    ipv6 = hcloud_primary_ip.www_ipv6.id
  }
}

resource "hcloud_firewall" "www" {
  name = "www"

  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall_attachment" "www" {
  firewall_id = hcloud_firewall.www.id
  label_selectors = [
    "type=www"
  ]
}

resource "hcloud_rdns" "www_ipv4" {
  dns_ptr       = "pelle.io"
  primary_ip_id = hcloud_primary_ip.www_ipv4.id
  ip_address    = hcloud_primary_ip.www_ipv4.ip_address
}

resource "hcloud_rdns" "www_ipv6" {
  dns_ptr       = "pelle.io"
  primary_ip_id = hcloud_primary_ip.www_ipv6.id
  ip_address    = hcloud_primary_ip.www_ipv6.ip_address
}

resource "hcloud_ssh_key" "pelle" {
  name       = "pelle"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_volume_attachment" "www" {
  volume_id = data.hcloud_volume.data.id
  server_id = hcloud_server.www.id
}

resource "tls_private_key" "www_host_key" {
  algorithm = "ED25519"
}

resource "tls_private_key" "deploy_key" {
  algorithm = "ED25519"
}