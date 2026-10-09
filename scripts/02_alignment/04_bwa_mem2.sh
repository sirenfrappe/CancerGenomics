#!/bin/bash
#SBATCH --job-name=bwa_mem2
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=bwa_mem2_%j.out
#SBATCH --error=bwa_mem2_%j.err

set -euo pipefail

module load BWA-MEM2/2.2.1-GCC-10.3.0 SAMtools/1.13-GCC-10.3.0

PROJECT_DIR=/data/users/qwang/CancerGenomics
INPUT_FASTQ_DIR="$PROJECT_DIR/output/01_qc/02_fastp"
OUTPUT_DIR="$PROJECT_DIR/output/02_alignment"
REF=/data/courses/cancergenomics/VAR_CALLING/bwa_idx/genome.fa

mkdir -p "$OUTPUT_DIR"

for SAMPLE in normal tumor; do
    bwa-mem2 mem -t 6 \
        -R "@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tLB:${SAMPLE}\tPL:ILLUMINA" \
        "$REF" \
        "$INPUT_FASTQ_DIR/${SAMPLE}.R1.fq.gz" \
        "$INPUT_FASTQ_DIR/${SAMPLE}.R2.fq.gz" | \
        samtools view -b -@ 1 -o "$OUTPUT_DIR/${SAMPLE}_aligned.bam" -
done
