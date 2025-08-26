#!/bin/bash

#Running this on the slurm master node!
# Sim (low-latency partition)
python3 edctl/cli.py submit --flow=sim --profile=latency

# Synth (throughput partition)
python3 edctl/cli.py submit --flow=synth --profile=throughput

# Watch
squeue -o "%.18i %.9P %.20j %.8u %.2t %.10M %.6D %R"
sinfo -N -l