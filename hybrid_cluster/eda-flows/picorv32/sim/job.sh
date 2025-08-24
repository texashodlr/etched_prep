#!/bin/bash
#SBATCH -c 1
#SBATCH --mem=8G
#SBATCH -o sim.log

module load verilator || true
make -C eda-flows/picorv32/sim run