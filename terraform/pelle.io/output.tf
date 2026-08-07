output "www_public_ipv4_address" {
  value = hcloud_primary_ip.www_public_ipv4.ip_address
}

output "www_public_ipv6_address" {
  value = cidrhost(hcloud_primary_ip.www_public_ipv6.ip_network, 1)
}

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
  value     = scaleway_iam_api_key.solidblocks_de.secret_key
  sensitive = true
}
