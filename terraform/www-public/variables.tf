variable "location" {
  type    = string
  default = "nbg1"
}

variable "volume_size" {
  type    = number
  default = 10

  validation {
    condition     = var.volume_size >= 10
    error_message = "Hetzner volumes start at 10 GB."
  }
}

variable "sites" {
  type = map(object({
    domains = optional(list(string), [])
  }))

  default = {
    "pelle.io" = {
      domains = ["krawallbu.de", "krawallbude.de", "pellepelster.de"]
    }
    "solidblocks.de" = {}
  }

  validation {
    condition = length(flatten([for site, config in var.sites : concat([site], config.domains)])) == length(
      distinct(flatten([for site, config in var.sites : concat([site], config.domains)]))
    )
    error_message = "A domain may only be used once across all sites."
  }

  validation {
    condition = alltrue([
      for domain in flatten([for site, config in var.sites : concat([site], config.domains)]) :
      contains(local.dns_zones, domain)
    ])
    error_message = "Every site and alternative domain must be a zone managed by this stack: ${join(", ", local.dns_zones)}."
  }
}
