#!/bin/bash
#SBATCH --job-name=elgaria_fastqc
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=12:00:00
#SBATCH --output=elgaria_fastqc_%j.out
#SBATCH --error=elgaria_fastqc_%j.err

set -euo pipefail

module load fastqc
module load multiqc

PROJECT="/data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata"

PACBIO="${PROJECT}/raw_reads/SRR19179400.hifi_reads.fastq.gz"
DOVETAIL="${PROJECT}/dovetail"

QC_DIR="${PROJECT}/qc"
FASTQC_DIR="${QC_DIR}/fastqc"
MULTIQC_DIR="${QC_DIR}/multiqc"

mkdir -p "$FASTQC_DIR"
mkdir -p "$MULTIQC_DIR"

echo "QC started: $(date)"
echo "Node: $(hostname)"

echo "FastQC version:"
fastqc --version

echo "MultiQC version:"
multiqc --version


# PacBio HiFi
fastqc \
    --threads "$SLURM_CPUS_PER_TASK" \
    --outdir "$FASTQC_DIR" \
    "$PACBIO"


# Dovetail / Omni-C raw runs
fastqc \
    --threads "$SLURM_CPUS_PER_TASK" \
    --outdir "$FASTQC_DIR" \
    "${DOVETAIL}/SRR19179398_R1.fastq.gz" \
    "${DOVETAIL}/SRR19179398_R2.fastq.gz" \
    "${DOVETAIL}/SRR19179399_R1.fastq.gz" \
    "${DOVETAIL}/SRR19179399_R2.fastq.gz"


# Combine FastQC reports
multiqc \
    "$FASTQC_DIR" \
    --outdir "$MULTIQC_DIR" \
    --filename Elgaria_multicarinata_multiqc.html


echo "QC finished: $(date)"
