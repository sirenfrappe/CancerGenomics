#!/bin/bash
#SBATCH --job-name=markduplicates
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=markduplicates_%j.out
#SBATCH --error=markduplicates_%j.err

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11 SAMtools/1.13-GCC-10.3.0

PROJECT_DIR=/data/users/qwang/CancerGenomics
INPUT_BAM_DIR="$PROJECT_DIR/output/02_alignment"
OUTPUT_DIR="$PROJECT_DIR/output/03_markduplicates"

mkdir -p "$OUTPUT_DIR"

for SAMPLE in normal tumor; do
    gatk --java-options "-Xmx24g -XX:ActiveProcessorCount=4" MarkDuplicates \
        -I "$INPUT_BAM_DIR/${SAMPLE}_sorted.bam" \
        -O "$OUTPUT_DIR/${SAMPLE}_marked.bam" \
        -M "$OUTPUT_DIR/${SAMPLE}_metrics.txt" \
        --TMP_DIR "$OUTPUT_DIR"
    samtools index "$OUTPUT_DIR/${SAMPLE}_marked.bam"
done
