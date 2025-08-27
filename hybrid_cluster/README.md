# Mini EDA Hybrid Cluster
Slurm, Ansible, and hardware aware jobs!

## Goal
Stand up a tiny hybrid cluster (VMs with a VMware backbone) with the called out tools below.
  Running an open-source EDA pipeline: Verilator Regression -> Yosys synth -> OpenROAD P&R on open RTL.

This repo is a mis-mash of Etched Representative projects [link:https://jobs.ashbyhq.com/Etched/1c03c13b-6f2e-44e7-b5bd-b7628412f8b9]:
"Design and deploy a fully automated, scalable hybrid HPC cluster, combining bare-metal servers and switches with cloud instances, provisioned through MaaS and orchestrated via SLURM and Kubernetes, optimized for mixed EDA workloads and parallel CI pipelines.

Develop a real-time observability system for ASIC toolchain jobs and distributed builds, integrating Prometheus, Grafana, and VictoriaMetrics with streaming telemetry, tracing, and alerting to detect performance regressions before they hit silicon."

### Hybrid Cluster Uses
- **Slurm** for EDA jobs
- **Ansible** for declarative provisioning
- **`edctl` CLI** to abstract job submission/logs/metrics

## Quick Start
0. `./create_structure.sh` -> Creates the barebones repo-skele
1. `cd infra/ansible && ./ansible_test` -> Verifies VM nodes are ready for the Slurm playbooks and installs slurms on nodes found in inventory.ini
2. `./ansible_validate` -> Verifies successful installation of slurm across nodes.
3. `cd playbooks && ./ansibble_eda_validate.sh` -> Installs EDA Tooling (Verilator/Yosys) on all nodes
3. On the slurm master node clone this repo and in the hybrid_cluster/ dir: `./eda-flows/picorv32/sim/job.sh` -> makes the actual eda-sim .o files
4. In the repo root (hybrid_cluster/) run: `./8-bit_job.sh` -> Runs the actual verilator regression job (via slurm) across the nodes.


## Implementation
1. Provisioned 3 VMs (VMware + Ansible)
2. Slurm Partitions for latency (fast CPU cores), and throughput (bulk jobs)
3. Exporters: node, SLurm, process
4. Wrapper like edctl that:
4.1. Submits parameterized sbatch with labels for latency or memory

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
