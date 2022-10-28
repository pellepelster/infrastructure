module "dns_pelle_io" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  domain    = "pelle.io"
}

module "dns_sanne_li" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  domain = "sanne.li"
}

module "dns_pellepelster_de" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  domain = "pellepelster.de"
}

module "dns_blcks_de" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  domain = "blcks.de"
}

module "dns_solidblocks_de" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  domain = "solidblocks.de"
}

module "dns_krawallbu_de" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  domain = "krawallbu.de"
}

module "dns_krawallbude_de" {
  source     = "../modules/default_zone"
  ip_address = hcloud_floating_ip.www.ip_address
  domain = "krawallbude.de"
}
