# Programmable Infra-as-Code Control Plane 
"Architect and implement a programmable infrastructure-as-code control plane, using Terraform, Ansible, and Puppet, to version, audit, and redeploy every layer of Etched's development stack with deterministic reproducibility."

## Main Components
1. Terraform: vSphere provider creating a 3-VM cluster (1x Master, 2x Worker), tagging and network assignment
2. Ansible: VM configuration (hostname/hosts/ssh), Munge, Slurm installation, 
3. Puppet: Enforcing slurm, potentially some dummy benchmarking scripts


### General Install
(WSL + Ubuntu)

#### Terraform
1. `wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg`
2. `echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`
3. `sudo apt update && sudo apt install terraform`
4. `terraform -version`

#### VMware
We're running this entire repo on my homelab VMware ESXi host (no vCenter).
We'll need OVFtool, see this download[https://developer.broadcom.com/tools/open-virtualization-format-ovf-tool/latest] and this article [https://rguske.github.io/post/vmware-ovftool-installation-was-unsuccessful-on-ubuntu-20/#fn:8]

192.168.1.250
ubuntu-server
ubuntu-user