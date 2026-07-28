terraform {
  backend "s3" {
    bucket       = "pelle-io-terraform-state"
    key          = "www-public/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
  }

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.63.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }

    scaleway = {
      source = "scaleway/scaleway"
    }

  }
  required_version = ">= 1.9.0"
}

provider "hcloud" {
}

provider "scaleway" {}
