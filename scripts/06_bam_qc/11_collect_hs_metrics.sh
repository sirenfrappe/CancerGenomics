#!/bin/bash
#SBATCH --job-name=collect_hs_metrics
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=08:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=collect_hs_metrics_%j.out
#SBATCH --error=collect_hs_metrics_%j.err

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11

PROJECT_DIR=/data/users/qwang/CancerGenomics
INPUT_BAM_DIR=/data/courses/cancergenomics/2026/bam
OUTPUT_DIR="$PROJECT_DIR/output/06_bam_qc"
REFERENCE_DIR="$PROJECT_DIR/../input/VAR_CALLING/reference"
REF=/data/courses/cancergenomics/2026/references/Homo_sapiens_assembly38.fasta
INTERVALS="$OUTPUT_DIR/exome_regions.interval_list"

mkdir -p "$OUTPUT_DIR"

gatk --java-options "-Xmx2g" BedToIntervalList \
    -I "$REFERENCE_DIR/exome_regions.bed" \
    -O "$INTERVALS" \
    -SD "${REF%.*}.dict"

for SAMPLE in AD2881 AD2882; do
    gatk --java-options "-Xmx24g -XX:ActiveProcessorCount=4" CollectHsMetrics \
        -I "$INPUT_BAM_DIR/${SAMPLE}.recal.bam" \
        -O "$OUTPUT_DIR/${SAMPLE}.recal.bam_hs_metrics.txt" \
        -R "$REF" \
        --BAIT_INTERVALS "$INTERVALS" \
        --TARGET_INTERVALS "$INTERVALS"
done
