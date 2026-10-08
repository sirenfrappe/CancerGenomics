#!/bin/bash
#SBATCH --job-name=fastqc_test
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-08
#SBATCH --output=fastqc_%j.out
#SBATCH --error=fastqc_%j.err

set -euo pipefail

PROJECT_DIR=/data/users/qwang/CancerGenomics
INPUT_FASTQ_DIR=/data/courses/cancergenomics/VAR_CALLING/fastq
OUTPUT_DIR="$PROJECT_DIR/output"
IMAGE=/containers/apptainer/fastqc-0.12.1.sif

mkdir -p "$OUTPUT_DIR"

for SAMPLE in normal tumor; do
    R1="$INPUT_FASTQ_DIR/${SAMPLE}.R1.fq.gz"
    R2="$INPUT_FASTQ_DIR/${SAMPLE}.R2.fq.gz"

    apptainer exec \
        --bind "$INPUT_FASTQ_DIR" \
        --bind "$OUTPUT_DIR" \
        "$IMAGE" \
        fastqc -t "$SLURM_CPUS_PER_TASK" \
        -o "$OUTPUT_DIR" "$R1" "$R2"
done

