#!/bin/bash

REMOTE_USER="ubuntu-user"

# Checking that Munge is running successfully on both worker nodes
munge -n | ssh "${REMOTE_USER}"@slurm-w1 unmunge
munge -n | ssh "${REMOTE_USER}"@slurm-w2 unmunge

# Checking Slurm daemons
## On master
systemctl is-active slurmctld

echo "Master network-binding status: "
lsof -iTCP:6817 -sTCP:LISTEN

STATUS=$(ssh "${REMOTE_USER}"@slurm-w1 "lsof -iTCP:6818 -sTCP:LISTEN")
echo "Slurm-w1 network-binding status: $STATUS"

STATUS=$(ssh "${REMOTE_USER}"@slurm-w2 "lsof -iTCP:6818 -sTCP:LISTEN")
echo "Slurm-w2 network-binding status: $STATUS"

STATUS=$(ssh "${REMOTE_USER}"@slurm-w1 "systemctl is-active slurmd")
echo "Slurm-w1 daemon status: $STATUS"
STATUS=$(ssh "${REMOTE_USER}"@slurm-w2 "systemctl is-active slurmd")
echo "Slurm-w2 daemon status: $STATUS"

echo "Slurm-master status: "
scontrol ping

echo "Slurm cluster status: "
sinfo -N -l

echo -e "\n\nRunning a simple distributed test."
srun -N3 -n3 hostname

cat > test.sh <<'EOF'
#!/bin/bash
echo "Hello from $(hostname)"
sleep 5
EOF

sbatch -N1 -p latency test.sh

echo -e "\n\nMonitoring:"
squeue -l