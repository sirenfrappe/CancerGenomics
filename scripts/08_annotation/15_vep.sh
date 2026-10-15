#!/bin/bash
#SBATCH --job-name=vep
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=vep_%j.out
#SBATCH --error=vep_%j.err
#SBATCH --reservation=class-407009-2026-10-15

set -euo pipefail

PROJECT_DIR=/data/users/qwang/CancerGenomics
IMAGE="$(dirname "$PROJECT_DIR")/vep_116.2.sif"
CACHE_DIR="$(dirname "$PROJECT_DIR")/vep_cache"
OUTPUT_DIR="$PROJECT_DIR/output/08_annotation"

mkdir -p "$OUTPUT_DIR"

apptainer exec --bind /data "$IMAGE" vep \
    -i "$PROJECT_DIR/input/cancer_variants.vcf" \
    --cache --dir_cache "$CACHE_DIR" \
    --species homo_sapiens \
    --offline \
    --force_overwrite \
    --assembly GRCh38 \
    --format vcf \
    --symbol \
    --sift b \
    --polyphen b \
    --pick \
    --domains \
    --output_file "$OUTPUT_DIR/cancer_variants.vep.txt"
