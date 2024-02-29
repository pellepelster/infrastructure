module "dns_pelle_io" {
  source       = "../modules/default_zone"
  ipv4_address = hcloud_server.www.ipv4_address
  ipv6_address = hcloud_server.www.ipv6_address
  domain       = "pelle.io"
  depends_on   = [hcloud_server.www]
}

module "dns_sanne_li" {
  source       = "../modules/default_zone"
  ipv4_address = hcloud_server.www.ipv4_address
  ipv6_address = hcloud_server.www.ipv6_address
  domain       = "sanne.li"
  depends_on   = [hcloud_server.www]
}

module "dns_pellepelster_de" {
  source       = "../modules/default_zone"
  ipv4_address = hcloud_server.www.ipv4_address
  ipv6_address = hcloud_server.www.ipv6_address
  domain       = "pellepelster.de"
  depends_on   = [hcloud_server.www]
}

module "dns_blcks_de" {
  source       = "../modules/default_zone"
  ipv4_address = hcloud_server.www.ipv4_address
  ipv6_address = hcloud_server.www.ipv6_address
  domain       = "blcks.de"
  depends_on   = [hcloud_server.www]
}

module "dns_solidblocks_de" {
  source       = "../modules/default_zone"
  ipv4_address = hcloud_server.www.ipv4_address
  ipv6_address = hcloud_server.www.ipv6_address
  domain       = "solidblocks.de"
  depends_on   = [hcloud_server.www]
}

module "dns_krawallbu_de" {
  source       = "../modules/default_zone"
  ipv4_address = hcloud_server.www.ipv4_address
  ipv6_address = hcloud_server.www.ipv6_address
  domain       = "krawallbu.de"
  depends_on   = [hcloud_server.www]
}

module "dns_krawallbude_de" {
  source       = "../modules/default_zone"
  ipv4_address = hcloud_server.www.ipv4_address
  ipv6_address = hcloud_server.www.ipv6_address
  domain       = "krawallbude.de"
  depends_on   = [hcloud_server.www]
}
