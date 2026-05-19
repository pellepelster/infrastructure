resource "hcloud_zone_rrset" "tem" {
  zone = var.zone
  name = "tem"
  type = "TXT"
  ttl  = 60
  records = [
    { value = "\"v=spf1 ${scaleway_tem_domain.solidblocks.spf_config} -all\"" },
  ]
}

resource "hcloud_zone_rrset" "dkim" {
  zone = var.zone
  name = trimsuffix(scaleway_tem_domain.solidblocks.dkim_name, ".${var.zone}.")
  type = "TXT"
  ttl  = 60
  records = [
    {
      value = provider::hcloud::txt_record(scaleway_tem_domain.solidblocks.dkim_config)
    },
  ]
}

resource "hcloud_zone_rrset" "dmarc" {
  zone = var.zone
  name = "_dmarc.tem"
  type = "TXT"
  ttl  = 60
  records = [
    { value = "\"${scaleway_tem_domain.solidblocks.dmarc_config}\"" },
  ]
}

resource "hcloud_zone_rrset" "mx" {
  zone = var.zone
  name = "tem"
  type = "MX"
  ttl  = 60
  records = [
    { value = scaleway_tem_domain.solidblocks.mx_config },
  ]
}
