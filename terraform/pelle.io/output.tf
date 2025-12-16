output "s3_buckets" {
  value     = module.www_pelle_io.s3_buckets
  sensitive = true
}

output "s3_host" {
  value = module.www_pelle_io.s3_host
}
