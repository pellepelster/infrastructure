resource "hcloud_volume" "storage" {
  name     = "${var.hostname}-data"
  size     = 64
  format   = "ext4"
  location = var.location
}