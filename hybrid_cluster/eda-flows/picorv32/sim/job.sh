#!/bin/bash
#SBATCH -J sim-counter
#SBATCH -p latency
#SBATCH -c 1
#SBATCH --mem=2G
#SBATCH -o %x.%j.out

set -euo pipefail
echo "Host: $(hostname)"
# Low-latency pinning to CPU0 + local NUMA
if command -v numactl >/dev/null 2>&1; then
  numactl --localalloc --physcpubind=0 make -C eda-flows/picorv32/sim run
else
  make -C eda-flows/picorv32/sim run
fi
