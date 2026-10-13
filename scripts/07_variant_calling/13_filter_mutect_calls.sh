#!/bin/bash
#SBATCH --job-name=filter_mutect_calls
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=filter_mutect_calls_%j.out
#SBATCH --error=filter_mutect_calls_%j.err

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11 BCFtools/1.12-GCC-10.3.0

PROJECT_DIR=/data/users/qwang/CancerGenomics
OUTPUT_DIR="$PROJECT_DIR/output/07_variant_calling"
REF=/data/users/qwang/input/VAR_CALLING/reference/ref_genome.fa

mkdir -p "$OUTPUT_DIR"

gatk --java-options "-Xmx6g -XX:ActiveProcessorCount=4" FilterMutectCalls \
    -R "$REF" \
    -V "$OUTPUT_DIR/somatic.vcf.gz" \
    --stats "$OUTPUT_DIR/somatic.vcf.gz.stats" \
    --filtering-stats "$OUTPUT_DIR/somatic.filtering_stats.tsv" \
    -O "$OUTPUT_DIR/somatic.filtered.vcf.gz"

bcftools view -f PASS -Oz \
    -o "$OUTPUT_DIR/somatic.filtered.PASS.vcf.gz" \
    "$OUTPUT_DIR/somatic.filtered.vcf.gz"
bcftools index --tbi --force "$OUTPUT_DIR/somatic.filtered.PASS.vcf.gz"
