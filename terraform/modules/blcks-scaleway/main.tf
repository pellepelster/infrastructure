locals {
  name = "blcks-${var.environment}"
  tags = ["environment=${var.environment}"]
}

resource "scaleway_account_project" "project" {
  name = local.name
}

resource "scaleway_iam_application" "admin" {
  name = "${local.name}-admin"
  tags = local.tags
}

resource "scaleway_iam_policy" "admin" {
  name           = "${local.name}-admin"
  application_id = scaleway_iam_application.admin.id
  tags           = local.tags

  rule {
    project_ids          = [scaleway_account_project.project.id]
    permission_set_names = ["AllProductsFullAccess"]
  }

  rule {
    organization_id      = scaleway_account_project.project.organization_id
    permission_set_names = ["IAMManager"]
    condition            = "resource.name.startsWith(\"${local.name}\")"
  }

  rule {
    organization_id      = scaleway_account_project.project.organization_id
    permission_set_names = ["IAMApplicationManager"]
    condition            = "resource.name.startsWith(\"${local.name}\")"
  }

  rule {
    organization_id      = scaleway_account_project.project.organization_id
    permission_set_names = ["IAMReadOnly"]
  }
}

resource "scaleway_iam_api_key" "admin" {
  application_id     = scaleway_iam_application.admin.id
  description        = local.name
  default_project_id = scaleway_account_project.project.id
}
