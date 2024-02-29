terraform {
  required_providers {

    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.2.0"
    }

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.45.0"
    }

    template = {
      source = "hashicorp/template"
    }

    tls = {
      source  = "hashicorp/tls"
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
