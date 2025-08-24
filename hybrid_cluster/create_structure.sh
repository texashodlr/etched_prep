#!/bin/bash
# Create directory structure and empty files

mkdir -p infra/terraform
touch infra/terraform/main.tf

mkdir -p infra/ansible
touch infra/ansible/inventory.ini
mkdir -p infra/ansible/playbooks
touch infra/ansible/playbooks/slurm-master.yml
touch infra/ansible/playbooks/slurm-worker.yml
touch infra/ansible/playbooks/common.yml
mkdir -p infra/ansible/roles/slurm-master
mkdir -p infra/ansible/roles/slurm-worker
mkdir -p infra/ansible/roles/exporters

mkdir -p infra/packer
touch infra/packer/slurm-node.json

mkdir -p cluster/slurm
touch cluster/slurm/slurm.conf
touch cluster/slurm/cgroup.conf
touch cluster/slurm/gres.conf

mkdir -p cluster/k8s/prometheus
touch cluster/k8s/prometheus/kustomization.yaml
touch cluster/k8s/prometheus/values.yaml
mkdir -p cluster/k8s/grafana/dashboards
mkdir -p cluster/k8s/loki

mkdir -p eda-flows/picorv32/sim
mkdir -p eda-flows/picorv32/synth
mkdir -p eda-flows/picorv32/pnr
touch eda-flows/Makefile

mkdir -p edctl
touch edctl/__init__.py
touch edctl/cli.py

mkdir -p observability/alerts
touch observability/prometheus-rules.yml
touch observability/dashboards.json
touch observability/alerts/regression.yml

echo "Directory structure and empty files created."