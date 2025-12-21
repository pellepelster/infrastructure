module "dns_pelle_io" {
  source = "../modules/default_zone"
  zone   = "pelle.io"
}

resource "hcloud_ssh_key" "pelle" {
  name       = "pelle"
  public_key = file("~/.ssh/id_rsa.pub")
}

module "www_pelle_io" {
  source   = "https://github.com/pellepelster/solidblocks/releases/download/v0.4.8/terraform-hcloud-blcks-web-s3-docker-v0.4.8.zip"
  name     = "public"
  dns_zone = "pelle.io"

  ssh_keys = [hcloud_ssh_key.pelle.id]

  s3_buckets = [
    { name                     = "pelle.io",
      web_access_public_enable = true,
      web_access_domains       = ["pelle.io", "pellepelster.de", "krawallbu.de", "krawallbude.de"]
    },
    { name                     = "solidblocks.de",
      web_access_public_enable = true,
      web_access_domains       = ["solidblocks.de"]
    },
  ]
}

data "hcloud_server" "public" {
  name = "public"
}

module "dns_solidblocks_de" {
  source       = "../modules/default_zone"
  ipv4_address = data.hcloud_server.public.ipv4_address
  ipv6_address = data.hcloud_server.public.ipv6_address
  zone         = "solidblocks.de"
}

module "dns_krawallbu_de" {
  depends_on   = [module.www_pelle_io]
  source       = "../modules/default_zone"
  ipv4_address = data.hcloud_server.public.ipv4_address
  ipv6_address = data.hcloud_server.public.ipv6_address
  zone         = "krawallbu.de"
}

module "dns_krawallbude_de" {
  depends_on   = [module.www_pelle_io]
  source       = "../modules/default_zone"
  ipv4_address = data.hcloud_server.public.ipv4_address
  ipv6_address = data.hcloud_server.public.ipv6_address
  zone         = "krawallbude.de"
}

module "dns_pellepelster_de" {
  depends_on   = [module.www_pelle_io]
  source       = "../modules/default_zone"
  ipv4_address = data.hcloud_server.public.ipv4_address
  ipv6_address = data.hcloud_server.public.ipv6_address
  zone         = "pellepelster.de"
}

module "dns_sanne_li" {
  depends_on   = [module.www_pelle_io]
  source       = "../modules/default_zone"
  ipv4_address = data.hcloud_server.public.ipv4_address
  ipv6_address = data.hcloud_server.public.ipv6_address
  zone         = "sanne.li"
}

