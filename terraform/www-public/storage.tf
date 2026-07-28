resource "hcloud_volume" "www_public" {
  name              = "www-public-data"
  size              = var.volume_size
  server_id         = hcloud_server.www_public.id
  automount         = false
  delete_protection = true
}
