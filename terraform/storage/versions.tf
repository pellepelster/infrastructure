terraform {
  required_providers {
    hcloud = {
      source  = "terraform-providers/hcloud"
      version = "1.45.0"
    }
  }

  required_version = ">= 0.13"
}

provider "hcloud" {
  token = var.cloud_api_token
}
