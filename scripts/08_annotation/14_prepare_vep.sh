#!/bin/bash
#SBATCH --job-name=prepare_vep
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=prepare_vep_%j.out
#SBATCH --error=prepare_vep_%j.err
#SBATCH --reservation=class-407009-2026-10-08

set -euo pipefail

PROJECT_DIR=/data/users/qwang/CancerGenomics
IMAGE="$(dirname "$PROJECT_DIR")/vep_116.2.sif"
CACHE_DIR="$(dirname "$PROJECT_DIR")/vep_cache"
export APPTAINER_CACHEDIR="$(dirname "$PROJECT_DIR")/.apptainer/cache"
export APPTAINER_TMPDIR="$(dirname "$PROJECT_DIR")/.apptainer/tmp"

mkdir -p "$CACHE_DIR" "$APPTAINER_CACHEDIR" "$APPTAINER_TMPDIR"

apptainer pull "$IMAGE" docker://ensemblorg/ensembl-vep:release_116.2

apptainer exec --bind /data "$IMAGE" INSTALL.pl \
    -a c -s homo_sapiens -y GRCh38 \
    --CACHE_VERSION 116 -c "$CACHE_DIR" --USE_HTTPS_PROTO
