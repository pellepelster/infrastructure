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


/*
resource "scaleway_tem_domain_validation" "solidblocks" {
  domain_id = scaleway_tem_domain.solidblocks.id
  region    = "fr-par"
  timeout   = 300
}
 */