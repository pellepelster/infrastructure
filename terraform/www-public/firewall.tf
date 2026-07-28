locals {
  anywhere = ["0.0.0.0/0", "::/0"]
}

resource "hcloud_firewall" "www_public" {
  name = "www-public"

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = local.anywhere
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = local.anywhere
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = local.anywhere
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = local.anywhere
  }

  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "443"
    source_ips = local.anywhere
  }
}

resource "hcloud_firewall_attachment" "www_public" {
  firewall_id = hcloud_firewall.www_public.id
  server_ids  = [hcloud_server.www_public.id]
}
