#!/bin/bash
#SBATCH --job-name=apply_bqsr
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=apply_bqsr_%j.out
#SBATCH --error=apply_bqsr_%j.err

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11 SAMtools/1.13-GCC-10.3.0

PROJECT_DIR=/data/users/qwang/CancerGenomics
INPUT_BAM_DIR="$PROJECT_DIR/output/03_markduplicates"
OUTPUT_DIR="$PROJECT_DIR/output/05_bqsr"
REF=/data/courses/cancergenomics/VAR_CALLING/bwa_idx/genome.fa

mkdir -p "$OUTPUT_DIR"

for SAMPLE in normal tumor; do
    gatk --java-options "-Xmx24g -XX:ActiveProcessorCount=4" ApplyBQSR \
        -R "$REF" \
        -I "$INPUT_BAM_DIR/${SAMPLE}_marked.bam" \
        --bqsr-recal-file "$OUTPUT_DIR/${SAMPLE}_recal.table" \
        -O "$OUTPUT_DIR/${SAMPLE}_bqsr.bam" \
        --create-output-bam-index false
    samtools index "$OUTPUT_DIR/${SAMPLE}_bqsr.bam"
done
