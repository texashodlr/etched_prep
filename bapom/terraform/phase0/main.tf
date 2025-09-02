# Default fabric
data "maas_fabric" "fabric" {
    name = var.fabric_name
}

# Subnet to use for PXE/deployment
data "maas_subnet" "deploy" {
    cidr = var.deploy_cidr
}

# Ansible user
data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-init/user-data.yaml.tmpl", {
      ansible_pubkey = fileexists("~/.ssh/id_ed25519.pub") ? file("~/.ssh/id_ed25519.pub") : ""
    })
  }
}



# Deployment of Pete and Andy
resource "maas_instance" "3070-box" {
    hostname = var.host_a_hostname

    deploy_params{
        distro_series = var.distro_series
        user_data = data.cloudinit_config.user_data.rendered
    }
}

resource "maas_instance" "1070-box" {
  hostname = var.host_b_hostname

  deploy_params {
    distro_series = var.distro_series
    user_data     = data.cloudinit_config.user_data.rendered
  }
}