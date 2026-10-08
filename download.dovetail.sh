#!/bin/bash
#SBATCH --job-name=elgaria_dovetail
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --gres=lscratch:200
#SBATCH --time=12:00:00
#SBATCH --output=elgaria_dovetail_%j.out
#SBATCH --error=elgaria_dovetail_%j.err

set -euo pipefail

module load sratoolkit/3.4.0
module load pigz

OUTDIR="/data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata/dovetail"
TMPDIR="/lscratch/$SLURM_JOB_ID"

mkdir -p "$OUTDIR"

echo "Job started: $(date)"
echo "Running on: $(hostname)"
echo "Job ID: $SLURM_JOB_ID"
echo "Output directory: $OUTDIR"
echo "Scratch directory: $TMPDIR"
echo "SRA Toolkit:"
fasterq-dump --version

# Download SRA runs
prefetch SRR19179398
prefetch SRR19179399

# Convert SRR19179398 to paired FASTQ
fasterq-dump SRR19179398 \
    --split-files \
    --threads "$SLURM_CPUS_PER_TASK" \
    --temp "$TMPDIR" \
    --outdir "$OUTDIR"

# Convert SRR19179399 to paired FASTQ
fasterq-dump SRR19179399 \
    --split-files \
    --threads "$SLURM_CPUS_PER_TASK" \
    --temp "$TMPDIR" \
    --outdir "$OUTDIR"

# Compress FASTQ files
pigz -p "$SLURM_CPUS_PER_TASK" \
    "$OUTDIR"/SRR19179398_1.fastq \
    "$OUTDIR"/SRR19179398_2.fastq \
    "$OUTDIR"/SRR19179399_1.fastq \
    "$OUTDIR"/SRR19179399_2.fastq

# Rename to R1/R2 convention
mv "$OUTDIR/SRR19179398_1.fastq.gz" "$OUTDIR/SRR19179398_R1.fastq.gz"
mv "$OUTDIR/SRR19179398_2.fastq.gz" "$OUTDIR/SRR19179398_R2.fastq.gz"

mv "$OUTDIR/SRR19179399_1.fastq.gz" "$OUTDIR/SRR19179399_R1.fastq.gz"
mv "$OUTDIR/SRR19179399_2.fastq.gz" "$OUTDIR/SRR19179399_R2.fastq.gz"

echo
echo "Final files:"
ls -lh "$OUTDIR"/SRR1917939*.fastq.gz

echo
echo "Job finished: $(date)"
