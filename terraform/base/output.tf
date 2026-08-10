output "pelle_io_organization_id" {
  value = data.aws_organizations_organization.pelle_io.id
}

output "pelle_io_account_id" {
  value = aws_organizations_account.pelle_io.id
}

output "pelle_io_admin_access_key" {
  value     = aws_iam_access_key.pelle_io_admin.id
  sensitive = true
}

output "pelle_io_admin_secret_access_key" {
  value     = aws_iam_access_key.pelle_io_admin.secret
  sensitive = true
}

output "blcks_dev_account_id" {
  value = aws_organizations_account.blcks_dev.id
}

output "blcks_dev_admin_access_key" {
  value     = module.blcks_dev_aws.admin_access_key
  sensitive = true
}

output "blcks_dev_admin_secret_access_key" {
  value     = module.blcks_dev_aws.admin_secret_access_key
  sensitive = true
}

output "blcks_dev_scaleway_access_key" {
  value     = module.blcks_dev_scaleway.access_key
  sensitive = true
}

output "blcks_dev_scaleway_secret_key" {
  value     = module.blcks_dev_scaleway.secret_key
  sensitive = true
}

output "blcks_dev_admin_password" {
  value     = module.blcks_dev_aws.admin_password
  sensitive = true
}

output "blcks_dev_project_id" {
  value = module.blcks_dev_scaleway.project_id
}

output "blcks_prod_account_id" {
  value = aws_organizations_account.blcks_prod.id
}

output "blcks_prod_admin_access_key" {
  value     = module.blcks_prod_aws.admin_access_key
  sensitive = true
}

output "blcks_prod_admin_secret_access_key" {
  value     = module.blcks_prod_aws.admin_secret_access_key
  sensitive = true
}

output "blcks_prod_scaleway_access_key" {
  value     = module.blcks_prod_scaleway.access_key
  sensitive = true
}

output "blcks_prod_scaleway_secret_key" {
  value     = module.blcks_prod_scaleway.secret_key
  sensitive = true
}

output "blcks_prod_admin_password" {
  value     = module.blcks_prod_aws.admin_password
  sensitive = true
}

output "blcks_prod_project_id" {
  value = module.blcks_prod_scaleway.project_id
}
