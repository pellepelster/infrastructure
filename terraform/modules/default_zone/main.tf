resource "hcloud_zone_rrset" "root_zone_ipv4" {
  count = var.ipv4_address == null ? 0 : 1
  zone  = var.zone
  name  = "@"
  type  = "A"
  ttl   = 60

  records = [
    { value = var.ipv4_address },
  ]
}

resource "hcloud_zone_rrset" "root_zone_ipv6" {
  count = var.ipv6_address == null ? 0 : 1
  zone  = var.zone
  name  = "@"
  type  = "AAAA"
  ttl   = 60

  records = [
    { value = var.ipv6_address },
  ]
}

resource "hcloud_zone_rrset" "spf" {
  zone = var.zone
  name = "@"
  type = "TXT"
  ttl  = 60
  records = [
    { value = "\"v=spf1 include:mailbox.org\"" },
  ]
}

resource "hcloud_zone_rrset" "mx" {
  zone = var.zone
  name = "@"
  type = "MX"
  ttl  = 60
  records = [
    { value = "10 mxext1.mailbox.org." },
    { value = "10 mxext2.mailbox.org." },
    { value = "30 mxext3.mailbox.org." },
  ]
}
