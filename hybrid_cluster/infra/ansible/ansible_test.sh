#!/bin/bash

#1 Ping Test 
ansible all -i inventory.ini -m ping

#2 Common Base
ansible-playbook -i inventory.ini playbooks/common.yml

#3 Master
ansible-playbook -i inventory.ini playbooks/slurm-master.yml

#4 Workers
ansible-playbook -i inventory.ini playbooks/slurm-worker.yml

#5 Exporters
ansible-playbook -i inventory.ini playbooks/exporters.yml