#!/bin/bash
#SBATCH --job-name=collect_metrics
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=collect_metrics_%j.out
#SBATCH --error=collect_metrics_%j.err

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11 R/4.1.0-foss-2021a

PROJECT_DIR=/data/users/qwang/CancerGenomics
INPUT_BAM_DIR="$PROJECT_DIR/output/03_markduplicates"
OUTPUT_DIR="$PROJECT_DIR/output/04_metrics"
REF=/data/courses/cancergenomics/VAR_CALLING/bwa_idx/genome.fa

mkdir -p "$OUTPUT_DIR"

for SAMPLE in normal tumor; do
    gatk --java-options "-Xmx24g -XX:ActiveProcessorCount=4" CollectMultipleMetrics \
        -I "$INPUT_BAM_DIR/${SAMPLE}_marked.bam" \
        -O "$OUTPUT_DIR/${SAMPLE}" \
        -R "$REF"
done

bash "$PROJECT_DIR/scripts/01_qc/03_multiqc.sh"
