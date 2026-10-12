#!/bin/bash
#SBATCH --job-name=flagstat
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=flagstat_%j.out
#SBATCH --error=flagstat_%j.err

set -euo pipefail

module load SAMtools/1.13-GCC-10.3.0

PROJECT_DIR=/data/users/qwang/CancerGenomics
INPUT_BAM_DIR=/data/courses/cancergenomics/2026/bam
OUTPUT_DIR="$PROJECT_DIR/output/06_bam_qc"

mkdir -p "$OUTPUT_DIR"

for SAMPLE in AD2881 AD2882; do
    samtools flagstat -@ 3 "$INPUT_BAM_DIR/${SAMPLE}.recal.bam" \
        > "$OUTPUT_DIR/${SAMPLE}_flagstat.txt"
done
