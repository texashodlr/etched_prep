#!/bin/bash

# Simple bash script for ssh'ng into the nodes
export SSH_PASS='your_password'

for host in slurm-master slurm-w1 slurm-w2; do
    sshpass -e ssh-copy-id -o StrictKeyChecking=no ubuntu-user@"$host"
done