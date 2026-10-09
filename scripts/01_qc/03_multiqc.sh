#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=multiqc_%j.out
#SBATCH --error=multiqc_%j.err

set -euo pipefail

PROJECT_DIR=/data/users/qwang/CancerGenomics
OUTPUT_DIR="$PROJECT_DIR/output/01_qc/03_multiqc"
IMAGE=/containers/apptainer/multiqc-1.33.sif

mkdir -p "$OUTPUT_DIR"

apptainer exec \
    --bind "$PROJECT_DIR" \
    "$IMAGE" \
    multiqc "$PROJECT_DIR" -o "$OUTPUT_DIR"
