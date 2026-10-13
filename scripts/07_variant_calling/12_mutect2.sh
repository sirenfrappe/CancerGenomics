#!/bin/bash
#SBATCH --job-name=mutect2
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=08:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=mutect2_%j.out
#SBATCH --error=mutect2_%j.err

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11

PROJECT_DIR=/data/users/qwang/CancerGenomics
INPUT_DIR=/data/users/qwang/input/VAR_CALLING
INPUT_BAM_DIR="$INPUT_DIR/alignments"
REFERENCE_DIR="$INPUT_DIR/reference"
RESOURCE_DIR="$INPUT_DIR/resources"
OUTPUT_DIR="$PROJECT_DIR/output/07_variant_calling"
REF="$REFERENCE_DIR/ref_genome.fa"
INTERVALS="$REFERENCE_DIR/exome_regions.bed.interval_list"

mkdir -p "$OUTPUT_DIR"

gatk --java-options "-Xmx24g -XX:ActiveProcessorCount=4" Mutect2 \
    -R "$REF" \
    --intervals "$INTERVALS" \
    -I "$INPUT_BAM_DIR/tumor.recal.bam" \
    -I "$INPUT_BAM_DIR/normal.recal.bam" \
    -normal normal \
    --germline-resource "$RESOURCE_DIR/af-only-gnomad.hg38.subset.vcf.gz" \
    --panel-of-normals "$RESOURCE_DIR/1000g_pon.hg38.subset.vcf.gz" \
    -O "$OUTPUT_DIR/somatic.vcf.gz"
