#!/bin/bash
#SBATCH -J synth-counter
#SBATCH -p batch
#SBATCH -c 2
#SBATCH --mem=2G
#SBATCH -o %x.%j.out

set -euo pipefail
echo "Host: $(hostname)"
yosys -q -s eda-flows/picorv32/synth/synth.ys | tee yosys.log
grep -E "=== counter|Number of cells" -A3 yosys.log || true
