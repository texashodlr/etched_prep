#!/bin/bash

# Dry run test check
echo "Executing dry-run!"
ansible-playbook -i inventory.ini playbooks/clean-up.yml --check -e cleanup_confirm=true
echo "Sleeping for 10 seconds incase you want to abort"
Sleep 10

echo "Executing live-fire delete all!"
ansible-playbook -i inventory.ini playbooks/clean-up.yml -e cleanup_confirm=true