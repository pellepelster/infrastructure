resource "github_actions_secret" "hcloud_token" {
  repository      = "infrastructure"
  secret_name     = "HCLOUD_TOKEN"
  plaintext_value = var.hcloud_token
}

resource "github_actions_secret" "scw_access_key" {
  repository      = "infrastructure"
  secret_name     = "SCW_ACCESS_KEY"
  plaintext_value = var.scw_access_key
}

resource "github_actions_secret" "scw_secret_key" {
  repository      = "infrastructure"
  secret_name     = "SCW_SECRET_KEY"
  plaintext_value = var.scw_secret_key
}

resource "github_actions_secret" "scw_default_organization_id" {
  repository      = "infrastructure"
  secret_name     = "SCW_DEFAULT_ORGANIZATION_ID"
  plaintext_value = var.scw_default_organization_id
}

resource "github_actions_secret" "aws_access_key_id" {
  repository      = "infrastructure"
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id
}

resource "github_actions_secret" "aws_secret_access_key" {
  repository      = "infrastructure"
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key
}
