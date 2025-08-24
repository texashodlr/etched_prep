# Mini EDA Hybrid Cluster
Slurm, k8s, and hardware aware jobs!

## Goal
Stand up a tiny hybrid cluster (VMs with a VMware backbone) with the called out tools below.
  Running an open-source EDA pipeline: Verilator Regression -> Yosys synth -> OpenROAD P&R on open RTL.
- **Slurm** for EDA jobs
- **Kubernetes** for services
- **Ansible/Terraform** for declarative provisioning
- **Observability** via exporters, PromQL rules, and dashboards
- **`edctl` CLI** to abstract job submission/logs/metrics

## Quick Start
0. `./create_structure.sh` -> Creates the barebones repo-skele
1. `cd infra/terraform && terraform apply` -> Brings up the VM nodes
2. `ansible-playbook playbooks/common.yml -i inventory.ini`
3. `make -C eda-flows/picorv32 sim` -> run Verilator regression
4. `python edctl/cli.py submit --flow=sim --profile=latency`

Dashboards: `kubectl port-forward svc/grafana 3000:3000`

## Implementation
1. Provisioned 3-6 VMs (Terraform + Ansible)
2. Slurm Partitions for latency (fast CPU cores), and throughput (bulk jobs)
3. Exporters: node, SLurm, process; Prometheus + Victoria Metrics + Grafana on K8s
4. Wrapper like edctl that:
4.1. Submits parameterized sbatch with labels for latency or memory
4.2. Emits job metadata as Prometheus pushgateway metrics
4.3. Attaches and OpenTelemetry trace context.

## VM Requirements
1. 1x Slurm Master with `Ubuntu 22.04.5-live-server`
2. 2x Slurm Workers with `Ubuntu 22.04.5-live-server`

All specs are the same and as follows:
- 2 vCPUs
- 8GB RAM


## Repo Skeleton

hybrid_cluster/
├── README.md
├── infra/
│   ├── terraform/          # Cluster provisioning (VMs, cloud, bare metal)
│   │   └── main.tf
│   ├── ansible/            # Node configuration (Slurm, exporters, deps)
│   │   ├── inventory.ini
│   │   ├── playbooks/
│   │   │   ├── slurm-master.yml
│   │   │   ├── slurm-worker.yml
│   │   │   └── common.yml
│   │   └── roles/
│   │       ├── slurm-master/
│   │       ├── slurm-worker/
│   │       └── exporters/
│   └── packer/             # (optional) golden image builds
│       └── slurm-node.json
├── cluster/
│   ├── slurm/              # Slurm configs
│   │   ├── slurm.conf
│   │   ├── cgroup.conf
│   │   └── gres.conf
│   └── k8s/                # Kubernetes manifests
│       ├── prometheus/
│       │   ├── kustomization.yaml
│       │   └── values.yaml
│       ├── grafana/
│       │   └── dashboards/
│       └── loki/
├── eda-flows/
│   ├── picorv32/           # Example open-source RTL design
│   │   ├── sim/            # Verilator testbenches
│   │   ├── synth/          # Yosys synthesis scripts
│   │   └── pnr/            # OpenROAD flow scripts
│   └── Makefile            # “make sim / make synth / make pnr”
├── edctl/                  # Your developer-facing CLI wrapper
│   ├── __init__.py
│   └── cli.py
└── observability/
    ├── prometheus-rules.yml
    ├── dashboards.json
    └── alerts/
        └── regression.yml
