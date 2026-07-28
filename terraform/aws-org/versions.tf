terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  required_version = ">= 1.9.0"
}

provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "pelle_io"
  region = "eu-central-1"

  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.pelle_io.id}:role/OrganizationAccountAccessRole"
  }
}
