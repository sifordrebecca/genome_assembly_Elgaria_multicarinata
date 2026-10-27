#!/bin/bash
#SBATCH --job-name=elgaria_jellyfish
#SBATCH --cpus-per-task=32
#SBATCH --mem=200G
#SBATCH --time=48:00:00
#SBATCH --gres=lscratch:800
#SBATCH --output=jellyfish_%j.out
#SBATCH --error=jellyfish_%j.err

set -euo pipefail

module load jellyfish/2.3.1

PROJECT="/data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata"
READS="$PROJECT/raw_reads/SRR19179400.hifi_reads.fastq.gz"
OUTDIR="$PROJECT/qc/jellyfish"

KMER=21
THREADS="${SLURM_CPUS_PER_TASK:-32}"

mkdir -p "$OUTDIR"

echo "Job started: $(date)"
echo "Node: $(hostname)"
echo "Threads: $THREADS"
echo "Input: $READS"

jellyfish --version

# Verify input exists
[[ -f "$READS" ]] || {
    echo "FASTQ not found: $READS" >&2
    exit 1
}

# Use node-local scratch for the large Jellyfish database
WORKDIR="/lscratch/${SLURM_JOB_ID}"
mkdir -p "$WORKDIR"

JF_FILE="$WORKDIR/Elgaria_k${KMER}.jf"
HISTO_FILE="$OUTDIR/Elgaria_k${KMER}.histo"

echo "Counting canonical ${KMER}-mers..."

# Jellyfish cannot directly read .gz, so use a generator
GENERATOR_FILE="$WORKDIR/generator.txt"
printf 'zcat %q\n' "$READS" > "$GENERATOR_FILE"

jellyfish count \
    -C \
    -m "$KMER" \
    -s 2G \
    -t "$THREADS" \
    --generator="$GENERATOR_FILE" \
    --Generators=4 \
    -o "$JF_FILE"

echo "K-mer counting finished: $(date)"

echo "Generating histogram..."

jellyfish histo \
    -t "$THREADS" \
    -h 1000000 \
    "$JF_FILE" \
    > "$HISTO_FILE"

echo "Histogram written to:"
echo "$HISTO_FILE"

echo
echo "First 20 histogram rows:"
head -20 "$HISTO_FILE"

echo
echo "Job finished: $(date)"
