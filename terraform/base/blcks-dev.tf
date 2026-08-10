provider "aws" {
  alias  = "blcks_dev"
  region = "eu-central-1"

  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.blcks_dev.id}:role/OrganizationAccountAccessRole"
  }

  default_tags {
    tags = {
      environment = "dev"
    }
  }
}

resource "aws_organizations_account" "blcks_dev" {
  name      = "blcks-dev"
  email     = local.blcks_dev_account_email
  parent_id = data.aws_organizations_organization.pelle_io.roots[0].id

  role_name         = "OrganizationAccountAccessRole"
  close_on_deletion = true

  lifecycle {
    ignore_changes = [role_name]
  }
}

module "blcks_dev_aws" {
  source = "../modules/blcks-aws"

  environment = "dev"

  providers = {
    aws = aws.blcks_dev
  }
}

module "blcks_dev_scaleway" {
  source      = "../modules/blcks-scaleway"
  environment = "dev"
}

