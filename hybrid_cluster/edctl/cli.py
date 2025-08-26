# edctl/cli.py

import argparse, subprocess, sys, os

ROOT = os.path.dirname(os.path.dirname(__file__))

def submit(args):
    design = args.design
    flow   = args.flow
    job = os.path.join(ROOT, f"../eda-flows/{design}/{flow}/job.sh")
    if not os.path.exists(job):
        print(f"Missing job script: {job}", file=sys.stderr); sys.exit(1)

    # Mapping profiles to partitions
    partition = {"latency": "latency", "throughput": "batch"}[args.profile]
    cmd = [
        "sbatch", "-p", partition, "--job-name", args.flow,
        f"eda-flows/{args.design}/{args.flow}/job.sh"
    ]
    print("Submitting:", " ".join(cmd))
    subprocess.run(cmd)

def main():
    p = argparse.ArgumentParser(prog="edctl")
    sub = p.add_subparsers(dest="cmd")

    s = sub.add_parser("submit")
    s.add_argument("--flow", required=True, choices=["sim", "synth","pnr"])
    s.add_argument("--design", default="picorv32")
    s.add_argument("--profile", choices=["latency", "throughput"], default="throughput")
    s.set_defaults(func=submit)
    args = p.parse_args()
    if hasattr(args, "func"): args.func(args)
    else: p.print_help()

if __name__ == "__main__":
    main()