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
# the mail, DKIM and DMARC names below still win.
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

resource "hcloud_zone_rrset" "spf" {
  zone = var.zone
  name = "@"
  type = "TXT"
  ttl  = 60
  records = [
    { value = "\"protonmail-verification=${var.proton_mail_verification}\"" },
    { value = "\"v=spf1 include:_spf.protonmail.ch ~all\"" },
  ]
}

resource "hcloud_zone_rrset" "mx" {
  zone = var.zone
  name = "@"
  type = "MX"
  ttl  = 60
  records = [
    { value = "10 mail.protonmail.ch." },
    { value = "20 mailsec.protonmail.ch." },
  ]
}

resource "hcloud_zone_rrset" "dkim1" {
  zone = var.zone
  name = "protonmail._domainkey"
  type = "CNAME"
  ttl  = 60
  records = [
    { value = var.domain_key1 },
  ]
}

resource "hcloud_zone_rrset" "dkim2" {
  zone = var.zone
  name = "protonmail2._domainkey"
  type = "CNAME"
  ttl  = 60
  records = [
    { value = var.domain_key2 },
  ]
}

resource "hcloud_zone_rrset" "dkim3" {
  zone = var.zone
  name = "protonmail3._domainkey"
  type = "CNAME"
  ttl  = 60
  records = [
    { value = var.domain_key3 },
  ]
}

resource "hcloud_zone_rrset" "dmarc" {
  zone = var.zone
  name = "_dmarc"
  type = "TXT"
  ttl  = 60
  records = [
    { value = "\"v=DMARC1; p=quarantine\"" },
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
