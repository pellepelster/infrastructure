output "project_id" {
  value = scaleway_account_project.project.id
}

output "access_key" {
  value     = scaleway_iam_api_key.admin.access_key
  sensitive = true
}

output "secret_key" {
  value     = scaleway_iam_api_key.admin.secret_key
  sensitive = true
}
