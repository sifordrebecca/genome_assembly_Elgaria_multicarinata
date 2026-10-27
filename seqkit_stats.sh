#!/bin/bash
#SBATCH --job-name=elgaria_seqkit
#SBATCH --cpus-per-task=8
#SBATCH --mem=16g
#SBATCH --time=12:00:00
#SBATCH --output=seqkit_stats_%j.out
#SBATCH --error=seqkit_stats_%j.err

set -euo pipefail

module load seqkit/2.13.0

PROJECT="/data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata"

echo "Started: $(date)"
echo "Node: $(hostname)"
echo "Threads: $SLURM_CPUS_PER_TASK"
seqkit version

# Check that every input exists before starting
for FILE in \
    "$PROJECT/raw_reads/SRR19179400.hifi_reads.fastq.gz" \
    "$PROJECT/dovetail/SRR19179398_R1.fastq.gz" \
    "$PROJECT/dovetail/SRR19179398_R2.fastq.gz" \
    "$PROJECT/dovetail/SRR19179399_R1.fastq.gz" \
    "$PROJECT/dovetail/SRR19179399_R2.fastq.gz"
do
    ls -lh "$FILE"
done

# Run SeqKit
seqkit --threads "$SLURM_CPUS_PER_TASK" stats \
    --all \
    --tabular \
    "$PROJECT/raw_reads/SRR19179400.hifi_reads.fastq.gz" \
    "$PROJECT/dovetail/SRR19179398_R1.fastq.gz" \
    "$PROJECT/dovetail/SRR19179398_R2.fastq.gz" \
    "$PROJECT/dovetail/SRR19179399_R1.fastq.gz" \
    "$PROJECT/dovetail/SRR19179399_R2.fastq.gz" \
    > "$PROJECT/qc/seqkit/seqkit_stats.tsv"

echo "Finished: $(date)"

cat "$PROJECT/qc/seqkit/seqkit_stats.tsv"
