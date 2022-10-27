data "hetznerdns_zone" "dns_zone" {
  name = var.domain
}

module "dns_pelle_io" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  zone_id    = data.hetznerdns_zone.dns_zone.id
}

module "dns_sanne_li" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  zone_id    = data.hetznerdns_zone.sanne_li_dns_zone.id
}

data "hetznerdns_zone" "sanne_li_dns_zone" {
  name = "sanne.li"
}

module "dns_pellepelster_de" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  zone_id    = data.hetznerdns_zone.pellepelster_de_dns_zone.id
}

data "hetznerdns_zone" "pellepelster_de_dns_zone" {
  name = "pellepelster.de"
}

module "dns_blcks_de" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  zone_id    = data.hetznerdns_zone.blcks_de_dns_zone.id
}

data "hetznerdns_zone" "blcks_de_dns_zone" {
  name = "blcks.de"
}

module "dns_solidblocks_de" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  zone_id    = data.hetznerdns_zone.solidblocks_de_dns_zone.id
}

data "hetznerdns_zone" "solidblocks_de_dns_zone" {
  name = "solidblocks.de"
}