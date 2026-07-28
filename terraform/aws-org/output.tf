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
