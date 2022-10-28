output "public_ip" {
  value = hcloud_floating_ip.www.ip_address
}

output "deploy_ssh_key" {
  value = tls_private_key.deploy_key.private_key_openssh
  sensitive = true
}