#!/bin/bash
#SBATCH --job-name=sort_index
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=sort_index_%j.out
#SBATCH --error=sort_index_%j.err

set -euo pipefail

module load SAMtools/1.13-GCC-10.3.0

PROJECT_DIR=/data/users/qwang/CancerGenomics
OUTPUT_DIR="$PROJECT_DIR/output/02_alignment"

mkdir -p "$OUTPUT_DIR"

for SAMPLE in normal tumor; do
    samtools sort -@ 8 \
        "$OUTPUT_DIR/${SAMPLE}_aligned.bam" \
        -o "$OUTPUT_DIR/${SAMPLE}_sorted.bam"
    samtools index "$OUTPUT_DIR/${SAMPLE}_sorted.bam"
done
