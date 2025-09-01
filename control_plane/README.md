# Programmable Infra-as-Code Control Plane 
"Architect and implement a programmable infrastructure-as-code control plane, using Terraform, Ansible, and Puppet, to version, audit, and redeploy every layer of Etched's development stack with deterministic reproducibility."

## Main Components
1. Terraform: vSphere provider creating a 3-VM cluster (1x Master, 2x Worker), tagging and network assignment
2. Ansible: VM configuration (hostname/hosts/ssh), Munge, Slurm installation, 
3. Puppet: Enforcing slurm, potentially some dummy benchmarking scripts

## Why this repo is valuable for Etched

By combining Terraform, Ansible, and Puppet into a unified control plane, this project demonstrates how Etched’s infrastructure can be versioned, audited, and redeployed with deterministic reproducibility. Every layer of the stack — from VM topology to Slurm configuration and EDA toolchain installs — is captured in code, stored in Git, and automatically enforced.

The result is that ASIC engineers spend less time debugging infrastructure and more time running high-value simulations. Failed nodes or drifted configs self-heal in minutes, new clusters can be spun up and validated in hours, and observability hooks ensure issues are caught before they impact tape-out timelines. This translates directly into faster iteration cycles, higher throughput of simulation workloads, and ultimately a shorter path to silicon.

In business terms: Etched sells better chips, faster. By reducing operational friction and guaranteeing reproducibility, this IaC approach directly increases engineering velocity and improves time-to-market for model-specific ASICs.

### Terraform
- All VM definitions (CPU, memory, disk, network) live as code (.tf).
- Cluster topology can be recreated deterministically on any ESXi host.
- Version-controlled in Git → infra diffs are reviewable & auditable.

### Ansible
- Declarative configuration of every node: Munge keys, Slurm configs, EDA toolchain.
- Idempotent --> re-running Ansible guarantees drift correction (if a file is deleted, it’s restored).
- Playbooks live in repo --> auditable change history of configs.

### Puppet
- Ensures continuous state enforcement. Even if a node drifts (service stopped, package removed), Puppet periodically re-applies the baseline.
- `site.pp` describes minimal desired state (Slurm + Munge + toolchain present and running).
- Logs every run --> audit trail of corrections.
- Combined with Git-backed manifests, any rollback or redeploy is deterministic.


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

1. Download the Linux zip for 5.0.0 and unzip then move that ovftool dir to /usr/bin/
2. `export PATH="/usr/bin/ovftool:$PATH"`
3. `echo 'export PATH="/usr/bin/ovftool:$PATH"' >> ~/.bashrc`
4. `ovftool --version`

