terraform {
  required_version = ">= 1.4.0"
  required_providers {
    maas      = { source = "canonical/maas", version = "~> 3.6" }
    cloudinit = { source = "hashicorp/cloudinit", version = "~> 2.3" }
  }
}

provider "maas" {
  api_version         = "2.0"
  api_url             = var.maas_api_url          # http://localhost:5240/MAAS
  api_key             = var.maas_api_key          # from MAAS UI --> your user --> API keys
  installation_method = "snap"
}
