terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.57.0"
    }

    template = {
      source = "hashicorp/template"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }

    github = {
      source  = "integrations/github"
      version = "6.9.0"
    }

  }

  required_version = ">= 0.13"
}

provider "hcloud" {
}

provider "github" {
}
