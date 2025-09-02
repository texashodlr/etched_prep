output "host_a_system_id" { value = maas_instance.host_a.system_id }
output "host_a_system_id" { value = maas_instance.host_a.system_id }

output "hostnames" { value = [var.host_a_hostname, var.host_b_hostname]}