output "smtp_host" {
  value = scaleway_tem_domain.solidblocks.smtp_host
}

output "smtp_port" {
  value = scaleway_tem_domain.solidblocks.smtps_port
}

output "smtp_user" {
  value = scaleway_tem_domain.solidblocks.smtps_auth_user
}

output "smtp_password" {
  value = scaleway_iam_api_key.solidblocks_de.secret_key
  sensitive = true
}
