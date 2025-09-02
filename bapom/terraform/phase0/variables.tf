variable "maas_api_url" { type = string }
variable "maas_api_key" { type = string, sensitive = true }

# Network lookups (set to match your MAAS)
variable "fabric_name" { type = string, default = "bapom-net" }   # or "maas" in some installs
variable "deploy_cidr" { type = string, default = "192.168.2.0/24" }

# Hosts you want to deploy (must already exist in MAAS with these hostnames or tags)
variable "host_a_hostname" { type = string, default = "3070-box" }
variable "host_b_hostname" { type = string, default = "1070-box" }

# OS to deploy
variable "distro_series"   { type = string, default = "jammy" }  # 22.04 = jammy
