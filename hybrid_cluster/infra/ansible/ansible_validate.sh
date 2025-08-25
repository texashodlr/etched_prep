#!/bin/bash

ansible-playbook -i inventory.ini playbooks/slurm-master.yml
sleep 1
ansible-playbook -i inventory.ini playbooks/slurm-worker.yml
sleep 1
ansible slurm_workers -i inventory.ini -b -m systemd -a 'name=slurmd state=restarted'
sleep 1
ansible slurm-master -i inventory.ini -b -m systemd -a 'name=slurmctld state=restarted'
sleep 1
ansible slurm-master -i inventory.ini -b -m systemd -a 'name=slurmd state=restarted'
sleep 1