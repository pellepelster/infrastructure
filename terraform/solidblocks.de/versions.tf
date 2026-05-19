terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.63.0"
    }
  }

  required_version = ">= 0.13"
}

provider "scaleway" {}

provider "hcloud" {
}
