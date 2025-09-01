# BAPOM
(Infrastructure) __B__ootstrapping __A__utomation (of) __P__ytorch-kernels (with) __O__bservability (and) __M__etrics -- _BAPOM_!
(Pronounced Bay-pom (like na-palm))

_BAPOM_ is an automated bare-metal (BM) pipeline provisioning solution which leverages several public solutions (MaaS, Terraform, Ansible, Kubernetes, Prometheus, Grafana) to allow me to do a _few_-click deployment of a basic pytorch kernels to naked BM nodes.

__Long-term Goal:__ Someone throws a bunch of metal at me and I can rapidly deploy beautiful pytorch kernels (or other workload!) to them with minimal friction. 

## Scope
- Infrastructure Boostrapping:
Using: [Canonical's Metal-as-a-Service](https://canonical.com/maas/how-it-works) serving DHCP+TFTP, commissioning, PXE and netboot autoinstall of Ubuntu Server 22.04.5 two my two GPU hosts:
-- Ampere Andy (1x Nvidia 3070)
-- Pascal Pete (2x Nvidia 1070s (SLI'd))
- Infrastructure Automation:
Using: [Hashicorp's Terraform](https://developer.hashicorp.com/terraform) and [Red Hat's Ansible](https://docs.ansible.com/)
-- Terraform to declare Pete and Andy, my subnets/VLAN, images and tags inside MAAS
-- Ansible to converge my OS packages, Nvidia drivers, container runtime, Nvidia's Container toolkit (slight hassle) and other services for this stack.
- Pytorch Workloads:
Using: [PyTorch](https://pytorch.org/), initially focused on it for benchmarking metal with GPUs, then can expand to my VMware homelab machine for CPU benchmarks.
-- PyTorch will be the vehicle for me to expose metrics with Prometheus and generate general signal about metal doing work
- Observability and Metrics:
Using: [Prometheus](https://prometheus.io/), [Grafana](https://grafana.com/), and maybe some [VictoriaMetrics](https://victoriametrics.com/)

## Reference BAPOMv1 Architecture
- Control-Plane: My laptop which connects to local wifi network containing the two metal machines (Andy & Pete).
- Metal Machines: 2x GPU nodes (Pete & Andy), provisioned via MASS which have the Nvidia driver/cuda/container suites and various k8s+pytorch dependencies.

## Workflow Phases
0. MAAS and Terraform
0.1 Install MAAS Region and Rack and then configure the provisioning VLAN. [Install Guide](https://canonical.com/maas/docs/how-to-get-maas-up-and-running)
`lsb_release -a` # I'm running Ubuntu 22.04.5 LTS on WSL for the Control Plane
`sudo snap install --channel=3.6/stable maas` # [MAAS Ver 3.6](https://canonical.com/maas/docs/release-notes-and-upgrade-instructions#p-9229-version-36-release-notes)
Do a quick verification:
`snap version` # Produces something like the below:
snap    2.71
snapd   2.71
series  16
ubuntu  22.04
kernel  5.15.167.4-microsoft-standard-WSL2 
`sudo snap services maas`          --> maas.pebble  enabled  active
`sudo snape services maas-test-db` --> maas-test-db.postgres  enabled  active
`sudo snap install maas-test-db`
`sudo maas init region+rack --database-uri maas-test-db:///` # Generally links to: URL: `default=http://172.17.221.61:5240/MAAS