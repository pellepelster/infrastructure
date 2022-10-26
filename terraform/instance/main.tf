terraform {
  required_providers {

    hetznerdns = {
      source = "timohirt/hetznerdns"
      version = "2.2.0"
    }

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.35.2"
    }

    template = {
      source = "hashicorp/template"
    }

    acme = {
      source  = "vancluever/acme"
      version = "2.1.2"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.3"
    }
  }

  required_version = ">= 0.13"
}

provider "tls" {
}

provider "hcloud" {
  token = var.cloud_api_token
}

provider "hetznerdns" {
  apitoken = var.dns_api_token
}

resource "hcloud_server" "www" {
  name        = "www"
  image       = "debian-10"
  server_type = "cx11"
  location    = var.location
  user_data   = data.template_file.user_data.rendered
  ssh_keys    = [
    hcloud_ssh_key.pelle.id
  ]
}

resource "hcloud_floating_ip_assignment" "ip_assignment" {
  floating_ip_id = hcloud_floating_ip.www.id
  server_id      = hcloud_server.www.id
}

resource "hcloud_floating_ip" "www" {
  name          = "www"
  type          = "ipv4"
  home_location = var.location
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