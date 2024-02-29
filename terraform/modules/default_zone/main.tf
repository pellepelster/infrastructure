data "hetznerdns_zone" "zone" {
  name = var.domain
}

resource "hetznerdns_record" "ipv4" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "@"
  value   = var.ipv4_address
  type    = "A"
  ttl     = 60
}

resource "hetznerdns_record" "ipv6" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "@"
  value   = var.ipv6_address
  type    = "AAAA"
  ttl     = 60
}

resource "hetznerdns_record" "spf" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "@"
  value   = "v=spf1 include:mailbox.org"
  type    = "TXT"
  ttl     = 60
}

resource "hetznerdns_record" "mx_10" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "@"
  value   = "10 mxext1.mailbox.org."
  type    = "MX"
  ttl     = 60
}

resource "hetznerdns_record" "mx_20" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "@"
  value   = "20 mxext2.mailbox.org."
  type    = "MX"
  ttl     = 60
}

resource "hetznerdns_record" "mx_30" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "@"
  value   = "30 mxext3.mailbox.org."
  type    = "MX"
  ttl     = 60
}

resource "hetznerdns_record" "ns_helium" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "@"
  value   = "helium.ns.hetzner.de."
  type    = "NS"
  ttl     = 60
}

resource "hetznerdns_record" "ns_hydrogen" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "@"
  value   = "hydrogen.ns.hetzner.com."
  type    = "NS"
  ttl     = 60
}

resource "hetznerdns_record" "ns_oxygen" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "@"
  value   = "oxygen.ns.hetzner.com."
  type    = "NS"
  ttl     = 60
}
