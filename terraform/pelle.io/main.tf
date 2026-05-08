module "dns_pelle_io" {
  source                   = "../modules/default_zone_proton"
  zone                     = "pelle.io"
  proton_mail_verification = "8c62e81b56370b65e8514a3033311d841dfc8529"
  domain_key1              = "protonmail.domainkey.devan3texasq6turgwuvtfbf6dzg73lkleusom4jw6hnectvkitma.domains.proton.ch."
  domain_key2              = "protonmail2.domainkey.devan3texasq6turgwuvtfbf6dzg73lkleusom4jw6hnectvkitma.domains.proton.ch."
  domain_key3              = "protonmail3.domainkey.devan3texasq6turgwuvtfbf6dzg73lkleusom4jw6hnectvkitma.domains.proton.ch."
}

module "dns_solidblocks_de" {
  source                   = "../modules/default_zone_proton"
  zone                     = "solidblocks.de"
  proton_mail_verification = "4dd4d97bbab9032d7c7ba7d0e83dd7c3c3094675"
  domain_key1              = "protonmail.domainkey.devan3texasq6turgwuvtfbf6dzg73lkleusom4jw6hnectvkitma.domains.proton.ch."
  domain_key2              = "protonmail2.domainkey.devan3texasq6turgwuvtfbf6dzg73lkleusom4jw6hnectvkitma.domains.proton.ch."
  domain_key3              = "protonmail3.domainkey.devan3texasq6turgwuvtfbf6dzg73lkleusom4jw6hnectvkitma.domains.proton.ch."
}

module "dns_krawallbu_de" {
  source       = "../modules/default_zone"
  zone         = "krawallbu.de"
}

module "dns_krawallbude_de" {
  source       = "../modules/default_zone"
  zone         = "krawallbude.de"
}

module "dns_pellepelster_de" {
  source       = "../modules/default_zone"
  zone         = "pellepelster.de"
}

module "dns_sanne_li" {
  source                   = "../modules/default_zone_proton"
  zone                     = "sanne.li"
  proton_mail_verification = "b11c9afa6db789ffa31bf3be1848e7c88e47a566"
  domain_key1              = "protonmail.domainkey.djdjiropb36yhd2pqovppzd2zfabfgi2mfwxjmpa4i3prqrb2324a.domains.proton.ch."
  domain_key2              = "protonmail2.domainkey.djdjiropb36yhd2pqovppzd2zfabfgi2mfwxjmpa4i3prqrb2324a.domains.proton.ch."
  domain_key3              = "protonmail3.domainkey.djdjiropb36yhd2pqovppzd2zfabfgi2mfwxjmpa4i3prqrb2324a.domains.proton.ch."
}

