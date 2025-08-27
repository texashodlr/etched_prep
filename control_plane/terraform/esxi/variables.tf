variable "esxi_host" {
  description = "ESXi IP"
  type        = string
}

variable "esxi_ssh_port" {
  description = "ESXi SSH port"
  type        = number
  default     = 22
}

variable "esxi_https_port" {
  description = "ESXi HTTPS/API port"
  type        = number
  default     = 443
}

variable "esxi_username" {
  description = "ESXi username (root)"
  type        = string
  default     = "root"
}

variable "esxi_password" {
  description = "ESXi password"
  type        = string
  sensitive   = true
}

variable "datastore" {
  description = "Datastore to place the VMs (datastore1)"
  type        = string
}

variable "portgroup_name" {
  description = "Existing ESXi port group name to attach NICs (VM Network)"
  type        = string
}

variable "clone_from_vm" {
  description = "Name (path) of a powered-off base VM on ESXi to clone"
  type        = string
}

variable "vm_vcpus" {
  description = "vCPU count for each VM"
  type        = number
  default     = 2
}

variable "vm_mem_mb" {
  description = "Memory MB for each VM"
  type        = number
  default     = 8192
}
