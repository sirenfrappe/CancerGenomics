#!/bin/bash
#SBATCH --job-name=vep_clinvar
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=vep_clinvar_%j.out
#SBATCH --error=vep_clinvar_%j.err
#SBATCH --reservation=class-407009-2026-10-15

set -euo pipefail

PROJECT_DIR=/data/users/qwang/CancerGenomics
IMAGE="$(dirname "$PROJECT_DIR")/vep_116.2.sif"
CACHE_DIR="$(dirname "$PROJECT_DIR")/vep_cache"
CLINVAR=/data/courses/cancergenomics/VAR_CALLING/resources/clinvar/clinvar.vcf.gz
OUTPUT_DIR="$PROJECT_DIR/output/08_annotation"
ANNOTATED="$OUTPUT_DIR/somatic.filtered.PASS.vep.clinvar.tsv"
FILTERED="$OUTPUT_DIR/somatic.filtered.PASS.vep.clinvar.filtered.tsv"

mkdir -p "$OUTPUT_DIR"

apptainer exec --bind /data "$IMAGE" vep \
    -i "$PROJECT_DIR/output/07_variant_calling/somatic.filtered.PASS.vcf.gz" \
    --cache --dir_cache "$CACHE_DIR" \
    --species homo_sapiens --assembly GRCh38 --offline \
    --format vcf --symbol --sift b --polyphen b --pick \
    --custom "file=$CLINVAR,short_name=ClinVar,format=vcf,type=exact,coords=0,fields=CLNSIG%CLNREVSTAT%CLNDN" \
    --tab --fields "Uploaded_variation,Location,Allele,SYMBOL,Consequence,IMPACT,SIFT,PolyPhen,ClinVar_CLNSIG,ClinVar_CLNREVSTAT,ClinVar_CLNDN" \
    --force_overwrite -o "$ANNOTATED"

apptainer exec --bind /data "$IMAGE" filter_vep \
    -i "$ANNOTATED" -o "$FILTERED" --force_overwrite \
    --filter 'SIFT matches deleterious or PolyPhen matches damaging or IMPACT in MODERATE,HIGH or ClinVar_CLNSIG matches [Pp]athogenic\b'

{
    printf 'Retained variants: '
    grep -vc '^#' "$FILTERED" || true
    printf '\nGene counts:\n'
    { grep -v '^#' "$FILTERED" || true; } | cut -f4 | sort | uniq -c | sort -nr
    printf '\nMutations (ID, location, allele, gene, consequence, impact):\n'
    { grep -v '^#' "$FILTERED" || true; } | cut -f1-6
} > "$OUTPUT_DIR/somatic.filtered.PASS.vep.clinvar.summary.txt"
