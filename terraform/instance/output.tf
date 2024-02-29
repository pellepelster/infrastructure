output "public_ip" {
  value = hcloud_server.www.ipv4_address
}

output "public_ipv6" {
  value = hcloud_server.www.ipv6_address
}

output "deploy_ssh_key" {
  value     = tls_private_key.deploy_key.private_key_openssh
  sensitive = true
}

/*
output "debug" {
  value = data.hcloud_datacenters.ds.datacenters
}*/
