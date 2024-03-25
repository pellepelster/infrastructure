variable "domain" {
  type = string
}

variable "ipv4_address" {
  type = string
}

variable "ipv6_address" {
  type = string
}

variable "enable_xmpp" {
  type    = bool
  default = false
}
