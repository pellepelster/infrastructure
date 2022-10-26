data "template_file" "user_data" {

  template = file("user_data.sh")

  vars = {
    floating_ip = hcloud_floating_ip.www.ip_address

    github_owner = var.github_owner
    github_token = var.github_token

    storage_device = data.hcloud_volume.data.linux_device

    domain   = var.domain
    hostname = var.hostname

    user_data_lib = file("${path.module}/user-data-lib.sh"),

    ssh_identity_ed25519_key = base64encode(tls_private_key.www_host_key.private_key_openssh)
    ssh_identity_ed25519_pub = base64encode(tls_private_key.www_host_key.public_key_openssh)
    deploy_public_key        = base64encode(tls_private_key.deploy_key.public_key_openssh)

    certificate = base64encode(acme_certificate.default_certificate.certificate_pem)
    private_key = base64encode(acme_certificate.default_certificate.private_key_pem)
  }
}

data "hcloud_volume" "data" {
  name = "${var.hostname}-data"
}

data "hetznerdns_zone" "dns_zone" {
  name = var.domain
}
