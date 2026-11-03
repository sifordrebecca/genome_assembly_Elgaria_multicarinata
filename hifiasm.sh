#!/bin/bash

#SBATCH --job-name=elgaria_hifiasm
#SBATCH --cpus-per-task=64
#SBATCH --mem=400g
#SBATCH --gres=lscratch:900
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --time=48:00:00
#SBATCH --output=hifiasm_%j.out
#SBATCH --error=hifiasm_%j.err

set -euo pipefail

module load hifiasm
module load gfatools
module load seqkit

PROJECT="/data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata"
OUTDIR="$PROJECT/assembly"

mkdir -p "$OUTDIR"
cd "$OUTDIR"

PREFIX="Elgaria_11-03-26"

HiFi="$PROJECT/raw_reads/SRR19179400.hifi_reads.fastq.gz"
HiC1="$PROJECT/dovetail/Elgaria_dovetail_R1.fastq.gz"
HiC2="$PROJECT/dovetail/Elgaria_dovetail_R2.fastq.gz"

echo "Started: $(date)"
echo "Node: $(hostname)"

# HiFi + Omni-C/Hi-C-style paired reads
hifiasm \
    -o "${PREFIX}.asm" \
    -t "$SLURM_CPUS_PER_TASK" \
    --h1 "$HiC1" \
    --h2 "$HiC2" \
    "$HiFi"

# Convert phased haplotype assemblies from GFA to FASTA
gfatools gfa2fa "${PREFIX}.asm.hic.hap1.p_ctg.gfa" \
    | seqkit sort -l -r \
    > "${PREFIX}.asm.hic.hap1.p_ctg.fa"

gfatools gfa2fa "${PREFIX}.asm.hic.hap2.p_ctg.gfa" \
    | seqkit sort -l -r \
    > "${PREFIX}.asm.hic.hap2.p_ctg.fa"

echo "Finished: $(date)"
