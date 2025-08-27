terraform {
  required_version = ">= 1.5.0"

  required_providers {
    esxi = {
      source  = "josenk/esxi"
    }
  }
}

# ---------- Provider ----------
# Talks directly to my homelab's standalone ESXi host. A Dell R430
provider "esxi" {
  esxi_hostname = var.esxi_host
  esxi_hostport = var.esxi_ssh_port
  esxi_hostssl  = var.esxi_https_port
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

# ---------- Local helpers ----------
locals {
  vm_common = {
    disk_store   = var.datastore
    numvcpus     = var.vm_vcpus
    memsize      = var.vm_mem_mb
    boot_firmware= "bios"      # EFI is cringe
    power        = "on"
    notes        = "Managed by Terraform (ESXi provider)"
    network_name = var.portgroup_name
  }
}

# ---------- Master ----------
resource "esxi_guest" "slurm_master" {
  guest_name     = "slurm-master"
  disk_store     = local.vm_common.disk_store
  numvcpus       = local.vm_common.numvcpus
  memsize        = local.vm_common.memsize
  boot_firmware  = local.vm_common.boot_firmware
  power          = local.vm_common.power
  notes          = local.vm_common.notes

  # Clone from a powered-off base VM already on the ESXi host
  clone_from_vm  = var.clone_from_vm   # In our case: "ubuntu-22045-base" (must exist & be off)

  network_interfaces {
    virtual_network = local.vm_common.network_name # esxi_portgroup.cluster_pg.name if created above
  }
}

# ---------- Worker 1 ----------
resource "esxi_guest" "slurm_w1" {
  guest_name     = "slurm-w1"
  disk_store     = local.vm_common.disk_store
  numvcpus       = local.vm_common.numvcpus
  memsize        = local.vm_common.memsize
  boot_firmware  = local.vm_common.boot_firmware
  power          = local.vm_common.power
  notes          = local.vm_common.notes
  clone_from_vm  = var.clone_from_vm

  network_interfaces {
    virtual_network = local.vm_common.network_name
  }
}

# ---------- Worker 2 ----------
resource "esxi_guest" "slurm_w2" {
  guest_name     = "slurm-w2"
  disk_store     = local.vm_common.disk_store
  numvcpus       = local.vm_common.numvcpus
  memsize        = local.vm_common.memsize
  boot_firmware  = local.vm_common.boot_firmware
  power          = local.vm_common.power
  notes          = local.vm_common.notes
  clone_from_vm  = var.clone_from_vm

  network_interfaces {
    virtual_network = local.vm_common.network_name
  }
}
