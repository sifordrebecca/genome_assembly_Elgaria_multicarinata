Elgaria multicarinata Genome Assembly 

This repository documents the workflow of the genome assembly for Elgaria multicarinata using: 
PacBio HiFi long reads for de novo genome assembly
Dovetail/Omni-C paired-end reads for scaffolding
NIH Biowulf for data storage / analysis
GitHub for scripts / documentation
Note: raw sequencing data are stored on Biowulf and are not committed to this repository
Analyses are performed on the NIH Biowulf computing cluster stored at:
/data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata/
Project Tasks
retrieve sequencing data from public repositories
assemble PacBio HiFi long reads
Retrieve and prep Dovetail/Omni-C paired-end reads for scaffolding
Species Information
Species: Elgaria multicarinata
Common name: Southern alligator lizard
BioProject: PRJNA808337
Specimen: rElgMul1

PacBio HiFi reads
PacBio HiFi reads for specimen rElgMul1 were obtained from GenomeArk's public Amazon S3 bucket. These long reads will be used for the initial de novo genome assembly. The PacBio HiFi files were downloaded recursively from GenomeArk using the AWS CLI: 
GenomeArk S3 directory:
https://genomeark.s3.amazonaws.com/index.html?prefix=species/Elgaria_multicarinata/rElgMul1/genomic_data/pacbio_hifi/ 
module load aws  
aws s3 cp \
    s3://genomeark/species/Elgaria_multicarinata/rElgMul1/genomic_data/pacbio_hifi/ \
    /data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata/raw_reads/ \
    --recursive \
    --no-sign-request

File name: SRR19179400.hifi_reads.fastq.gz
AWS version 2.15.26


Dovetail / Omni-C sequencing data
Two paired-end SRA runs were downloaded using NCBI SRA toolkit for use for scaffolding:
SRR19179398
SRR19179399
SRA Toolkit
module load sratoolkit/3.4.0
Because this Biowulf module requires local scratch space, jobs were run with /lscratch allocated through Slurm.
sinteractive \
    --cpus-per-task=8 \
    --mem=32g \
    --gres=lscratch:200 
Downloading the SRA runs
The two runs were retrieved using:
prefetch SRR19179398
prefetch SRR19179399
Each SRA run was then converted into paired-end FASTQ files with fasterq-dump.
fasterq-dump SRR19179398 \
    --split-files \
    --threads $SLURM_CPUS_PER_TASK \
    --temp /lscratch/$SLURM_JOB_ID \
    --outdir /data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata/dovetail
fasterq-dump SRR19179399 \
    --split-files \
    --threads $SLURM_CPUS_PER_TASK \
    --temp /lscratch/$SLURM_JOB_ID \
    --outdir /data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata/dovetail
The resulting FASTQ files were compressed with pigz and renamed using the R1/R2 convention.
Final files:
SRR19179398_R1.fastq.gz
SRR19179398_R2.fastq.gz
SRR19179399_R1.fastq.gz
SRR19179399_R2.fastq.gz
Read-count validation
Read counts were checked after conversion.
SRA run
R1 reads
R2 reads
SRR19179398
125,302,641
125,302,641
SRR19179399
128,222,089
128,222,089

Total number of read pairs across both runs: 253,524,730
The two runs were combined so that scaffolding software can use a single R1 file and a single R2 file.
R1 files were concatenated:
cat \
    SRR19179398_R1.fastq.gz \
    SRR19179399_R1.fastq.gz \
    > Elgaria_dovetail_R1.fastq.gz
R2 files were concatenated:
cat \
    SRR19179398_R2.fastq.gz \
    SRR19179399_R2.fastq.gz \
    > Elgaria_dovetail_R2.fastq.gz

= read count in each combined file is now 253,524,730 reads
The combined files are:
Elgaria_dovetail_R1.fastq.gz
Elgaria_dovetail_R2.fastq.gz
The original SRA FASTQ files are being retained for now.

Directory structure
Current project organization:
Elgaria_multicarinata/
├── raw_reads/
│   ├── [PacBio HiFi read files] SRR19179400.hifi_reads.fastq.gz
│
├── dovetail/
│   ├── SRR19179398_R1.fastq.gz
│   ├── SRR19179398_R2.fastq.gz
│   ├── SRR19179399_R1.fastq.gz
│   ├── SRR19179399_R2.fastq.gz
│   ├── Elgaria_dovetail_R1.fastq.gz
│   └── Elgaria_dovetail_R2.fastq.gz
│
├── readme.txt/




Data summary
Data
Source
Purpose
PacBio HiFi
GenomeArk / AWS S3
Initial de novo genome assembly
SRR19179398
NCBI SRA
Dovetail/Omni-C scaffolding
SRR19179399
NCBI SRA
Dovetail/Omni-C scaffolding

Next 
QC of the HiFi data
perform long-read genome assembly
evaluate assembly quality
use the combined Dovetail/Omni-C reads for scaffolding
evaluate the scaffolded assembly
document software, parameters, and outputs for each stage

