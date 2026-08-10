provider "aws" {
  alias  = "blcks_prod"
  region = "eu-central-1"

  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.blcks_prod.id}:role/OrganizationAccountAccessRole"
  }
}

resource "aws_organizations_account" "blcks_prod" {
  name      = "blcks-prod"
  email     = local.blcks_prod_account_email
  parent_id = data.aws_organizations_organization.pelle_io.roots[0].id

  role_name         = "OrganizationAccountAccessRole"
  close_on_deletion = true

  lifecycle {
    ignore_changes = [role_name]
  }
}

module "blcks_prod_aws" {
  source = "../modules/blcks-aws"

  environment = "prod"

  providers = {
    aws = aws.blcks_prod
  }
}

module "blcks_prod_scaleway" {
  source      = "../modules/blcks-scaleway"
  environment = "prod"
}

