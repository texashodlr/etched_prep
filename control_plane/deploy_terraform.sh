#!/bin/bash

cd terraform/esxi

terraform init

sleep 2

terraform plan -var-file=terraform.tfvars

sleep 2

terraform apply -var-file=terraform.tfvars