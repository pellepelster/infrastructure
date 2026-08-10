resource "hcloud_zone_rrset" "root_zone_ipv4" {
  zone = var.zone
  name = "@"
  type = "A"
  ttl  = 60

  records = [
    { value = var.ipv4_address },
  ]
}

resource "hcloud_zone_rrset" "root_zone_ipv6" {
  zone = var.zone
  name = "@"
  type = "AAAA"
  ttl  = 60

  records = [
    { value = var.ipv6_address },
  ]
}

# RFC 4592: a wildcard is only synthesised for names absent from the zone, so
# any explicit name in the zone still wins.
resource "hcloud_zone_rrset" "wildcard_zone_ipv4" {
  zone = var.zone
  name = "*"
  type = "A"
  ttl  = 60

  records = [
    { value = var.ipv4_address },
  ]
}

resource "hcloud_zone_rrset" "wildcard_zone_ipv6" {
  zone = var.zone
  name = "*"
  type = "AAAA"
  ttl  = 60

  records = [
    { value = var.ipv6_address },
  ]
}

# No mail is sent from these zones, so tell receivers to reject anything that
# claims otherwise.
resource "hcloud_zone_rrset" "spf" {
  zone = var.zone
  name = "@"
  type = "TXT"
  ttl  = 60

  records = [
    { value = "\"v=spf1 -all\"" },
  ]
}

resource "hcloud_zone_rrset" "dmarc" {
  zone = var.zone
  name = "_dmarc"
  type = "TXT"
  ttl  = 60

  records = [
    { value = "\"v=DMARC1; p=reject\"" },
  ]
}

# Caddy issues via let's encrypt and falls back to zerossl, which is sectigo.
resource "hcloud_zone_rrset" "caa" {
  zone = var.zone
  name = "@"
  type = "CAA"
  ttl  = 60

  records = [
    { value = "0 issue \"letsencrypt.org\"" },
    { value = "0 issue \"sectigo.com\"" },
  ]
}
