#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-08
#SBATCH --output=fastp_%j.out
#SBATCH --error=fastp_%j.err

set -euo pipefail

PROJECT_DIR=/data/users/qwang/CancerGenomics
INPUT_FASTQ_DIR=/data/courses/cancergenomics/VAR_CALLING/fastq
OUTPUT_DIR="$PROJECT_DIR/output/01_qc/02_fastp"
IMAGE=/containers/apptainer/fastp_0.24.1.sif

mkdir -p "$OUTPUT_DIR"

for SAMPLE in normal tumor; do
    apptainer exec \
        --bind "$INPUT_FASTQ_DIR" \
        --bind "$OUTPUT_DIR" \
        "$IMAGE" \
        fastp -w "$SLURM_CPUS_PER_TASK" \
        -i "$INPUT_FASTQ_DIR/${SAMPLE}.R1.fq.gz" \
        -I "$INPUT_FASTQ_DIR/${SAMPLE}.R2.fq.gz" \
        -o "$OUTPUT_DIR/${SAMPLE}.R1.fq.gz" \
        -O "$OUTPUT_DIR/${SAMPLE}.R2.fq.gz" \
        -h "$OUTPUT_DIR/${SAMPLE}.html" \
        -j "$OUTPUT_DIR/${SAMPLE}.json" \
        --detect_adapter_for_pe --cut_tail
done
