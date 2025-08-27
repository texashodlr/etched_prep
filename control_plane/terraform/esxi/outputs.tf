output "vm_names" {
    value = [
        esxi_guest.slurm_master.guest_name,
        esxi_guest.slurm_w1.guest_name,
        esxi_guest.slurm_w2.guest_name
    ]
}

output "esxi_datastore" {
    value = var.datastore
}