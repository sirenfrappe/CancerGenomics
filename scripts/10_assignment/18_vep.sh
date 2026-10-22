#!/bin/bash
#SBATCH --job-name=vep_somatic
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-22
#SBATCH --output=vep_somatic_%j.out
#SBATCH --error=vep_somatic_%j.err

set -euo pipefail

PROJECT_DIR=/data/users/qwang/CancerGenomics
VEP_DIR=/data/courses/cancergenomics/2026/VEP
INPUT_DIR="$VEP_DIR/input/Massimo_Maiolo_2025"
OUTPUT_DIR="$PROJECT_DIR/output/10_assignment"

mkdir -p "$OUTPUT_DIR"

apptainer exec --bind /data --bind "$VEP_DIR/vep_data:/vep_data" \
    "$VEP_DIR/vep.sif" vep \
    --dir /vep_data --cache --offline --assembly GRCh38 \
    --format vcf --vcf --force_overwrite --everything --pick \
    --input_file "$INPUT_DIR/somatic.filtered.PASS.vcf" \
    --output_file "$OUTPUT_DIR/somatic.filtered.PASS.vep.vcf" \
    --custom /vep_data/clinvar/clinvar.vcf.gz,ClinVar,vcf,exact,0,CLNSIG,CLNREVSTAT,CLNDN
