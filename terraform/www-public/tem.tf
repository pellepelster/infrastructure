resource "scaleway_account_project" "solidblocks" {
  name = "solidblocks"
}

resource "scaleway_tem_domain" "solidblocks" {
  project_id = scaleway_account_project.solidblocks.id
  accept_tos = true
  name       = "tem.solidblocks.de"
}

resource "scaleway_iam_application" "solidblocks_de" {
  name = "solidblocks.de"
}

resource "scaleway_iam_policy" "solidblocks_de_tem" {
  name           = "solidblocks.de-tem"
  application_id = scaleway_iam_application.solidblocks_de.id

  rule {
    project_ids          = [scaleway_account_project.solidblocks.id]
    permission_set_names = ["TransactionalEmailEmailSmtpCreate"]
  }
}

resource "scaleway_iam_api_key" "solidblocks_de" {
  application_id = scaleway_iam_application.solidblocks_de.id
  description    = "solidblocks.de"
}

resource "hcloud_zone_rrset" "tem" {
  zone = "solidblocks.de"
  name = "tem"
  type = "TXT"
  ttl  = 60
  records = [
    { value = "\"v=spf1 ${scaleway_tem_domain.solidblocks.spf_config} -all\"" },
  ]
}

resource "hcloud_zone_rrset" "dkim" {
  zone = "solidblocks.de"
  name = trimsuffix(scaleway_tem_domain.solidblocks.dkim_name, ".solidblocks.de.")
  type = "TXT"
  ttl  = 60
  records = [
    {
      value = provider::hcloud::txt_record(scaleway_tem_domain.solidblocks.dkim_config)
    },
  ]
}

resource "hcloud_zone_rrset" "dmarc" {
  zone = "solidblocks.de"
  name = "_dmarc.tem"
  type = "TXT"
  ttl  = 60
  records = [
    { value = "\"${scaleway_tem_domain.solidblocks.dmarc_config}\"" },
  ]
}

resource "hcloud_zone_rrset" "mx" {
  zone = "solidblocks.de"
  name = "tem"
  type = "MX"
  ttl  = 60
  records = [
    { value = scaleway_tem_domain.solidblocks.mx_config },
  ]
}
