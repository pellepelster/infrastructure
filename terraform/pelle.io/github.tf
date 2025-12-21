resource "github_actions_secret" "s3_host" {
  repository      = "pages"
  secret_name     = "S3_HOST"
  plaintext_value = module.www_pelle_io.s3_host
}

resource "github_actions_secret" "pelle_io_access_key" {
  repository      = "pages"
  secret_name     = "PELLE_IO_ACCESS_KEY"
  plaintext_value = module.www_pelle_io.s3_buckets[0].owner_key_id
}

resource "github_actions_secret" "pelle_io_secret_key" {
  repository      = "pages"
  secret_name     = "PELLE_IO_SECRET_KEY"
  plaintext_value = module.www_pelle_io.s3_buckets[0].owner_secret_key
}

resource "github_actions_secret" "solidblocks_de_access_key" {
  repository      = "pages"
  secret_name     = "SOLIDBLOCKS_DE_ACCESS_KEY"
  plaintext_value = module.www_pelle_io.s3_buckets[1].owner_key_id
}

resource "github_actions_secret" "solidblocks_de_secret_key" {
  repository      = "pages"
  secret_name     = "SOLIDBLOCKS_DE_SECRET_KEY"
  plaintext_value = module.www_pelle_io.s3_buckets[1].owner_secret_key
}
