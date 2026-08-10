locals {
  ipv4 = "178.104.11.60"
  ipv6 = "2a01:4f8:c2c:964d::1"
}

module "dns_pelle_io" {
  source                   = "../modules/default-zone-proton"
  zone                     = "pelle.io"
  ipv4_address             = local.ipv4
  ipv6_address             = local.ipv6
  proton_mail_verification = "8c62e81b56370b65e8514a3033311d841dfc8529"
  domain_key1              = "protonmail.domainkey.devan3texasq6turgwuvtfbf6dzg73lkleusom4jw6hnectvkitma.domains.proton.ch."
  domain_key2              = "protonmail2.domainkey.devan3texasq6turgwuvtfbf6dzg73lkleusom4jw6hnectvkitma.domains.proton.ch."
  domain_key3              = "protonmail3.domainkey.devan3texasq6turgwuvtfbf6dzg73lkleusom4jw6hnectvkitma.domains.proton.ch."
}

module "dns_solidblocks_de" {
  source                   = "../modules/default-zone-proton"
  zone                     = "solidblocks.de"
  ipv4_address             = local.ipv4
  ipv6_address             = local.ipv6
  proton_mail_verification = "4dd4d97bbab9032d7c7ba7d0e83dd7c3c3094675"
  domain_key1              = "protonmail.domainkey.dwi4fgxw3zzxfbrwuvbrskx2whipgvaa6kmlxxjlamfq47nrlu22a.domains.proton.ch."
  domain_key2              = "protonmail2.domainkey.dwi4fgxw3zzxfbrwuvbrskx2whipgvaa6kmlxxjlamfq47nrlu22a.domains.proton.ch."
  domain_key3              = "protonmail3.domainkey.dwi4fgxw3zzxfbrwuvbrskx2whipgvaa6kmlxxjlamfq47nrlu22a.domains.proton.ch."
}

module "dns_krawallbu_de" {
  source       = "../modules/default-zone"
  zone         = "krawallbu.de"
  ipv4_address = local.ipv4
  ipv6_address = local.ipv6
}

module "dns_krawallbude_de" {
  source       = "../modules/default-zone"
  zone         = "krawallbude.de"
  ipv4_address = local.ipv4
  ipv6_address = local.ipv6
}

module "dns_pellepelster_de" {
  source       = "../modules/default-zone"
  zone         = "pellepelster.de"
  ipv4_address = local.ipv4
  ipv6_address = local.ipv6
}

module "dns_sanne_li" {
  source                   = "../modules/default-zone-proton"
  zone                     = "sanne.li"
  ipv4_address             = local.ipv4
  ipv6_address             = local.ipv6
  proton_mail_verification = "b11c9afa6db789ffa31bf3be1848e7c88e47a566"
  domain_key1              = "protonmail.domainkey.djdjiropb36yhd2pqovppzd2zfabfgi2mfwxjmpa4i3prqrb2324a.domains.proton.ch."
  domain_key2              = "protonmail2.domainkey.djdjiropb36yhd2pqovppzd2zfabfgi2mfwxjmpa4i3prqrb2324a.domains.proton.ch."
  domain_key3              = "protonmail3.domainkey.djdjiropb36yhd2pqovppzd2zfabfgi2mfwxjmpa4i3prqrb2324a.domains.proton.ch."
}
