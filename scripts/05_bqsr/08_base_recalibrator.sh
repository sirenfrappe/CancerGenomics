#!/bin/bash
#SBATCH --job-name=base_recalibrator
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=base_recalibrator_%j.out
#SBATCH --error=base_recalibrator_%j.err

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11

PROJECT_DIR=/data/users/qwang/CancerGenomics
INPUT_BAM_DIR="$PROJECT_DIR/output/03_markduplicates"
OUTPUT_DIR="$PROJECT_DIR/output/05_bqsr"
REF=/data/courses/cancergenomics/VAR_CALLING/bwa_idx/genome.fa
KNOWN_DBSNP=/data/courses/cancergenomics/VAR_CALLING/dbsnp/GCF_000001405.40_alias.vcf.gz
KNOWN_INDELS=/data/courses/cancergenomics/VAR_CALLING/known_indels/resources_broad_hg38_v0_Mills_and_1000G_gold_standard.indels.hg38.vcf.gz

mkdir -p "$OUTPUT_DIR"

for SAMPLE in normal tumor; do
    gatk --java-options "-Xmx24g -XX:ActiveProcessorCount=4" BaseRecalibrator \
        -R "$REF" \
        -I "$INPUT_BAM_DIR/${SAMPLE}_marked.bam" \
        --known-sites "$KNOWN_DBSNP" \
        --known-sites "$KNOWN_INDELS" \
        -O "$OUTPUT_DIR/${SAMPLE}_recal.table"
done
