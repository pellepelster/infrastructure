data hetznerdns_zone "solidblocks_de_zone" {
  name = "solidblocks.de"
}

resource hetznerdns_record "root_a1" {
  zone_id = data.hetznerdns_zone.solidblocks_de_zone.id
  name    = "@"
  value   = "185.199.108.153"
  type    = "A"
  ttl     = 60
}

resource hetznerdns_record "root_a2" {
  zone_id = data.hetznerdns_zone.solidblocks_de_zone.id
  name    = "@"
  value   = "185.199.109.153"
  type    = "A"
  ttl     = 60
}

resource hetznerdns_record "root_a3" {
  zone_id = data.hetznerdns_zone.solidblocks_de_zone.id
  name    = "@"
  value   = "185.199.110.153"
  type    = "A"
  ttl     = 60
}

resource hetznerdns_record "root_a4" {
  zone_id = data.hetznerdns_zone.solidblocks_de_zone.id
  name    = "@"
  value   = "185.199.111.153"
  type    = "A"
  ttl     = 60
}
