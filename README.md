# *Elgaria multicarinata* Genome Assembly

This repository documents the genome assembly workflow for *Elgaria multicarinata* using:

- PacBio HiFi long reads for de novo genome assembly
- Dovetail/Omni-C paired-end reads for scaffolding
- NIH Biowulf for data storage / analysis
- GitHub for scripts / documentation

> **Note:** Raw sequencing data are stored on Biowulf and are not committed to this repository.

Analyses are performed on the NIH Biowulf computing cluster.

Project directory:

```text
/data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata/
```

## Project tasks

- Retrieve sequencing data from public repositories
- Assemble PacBio HiFi long reads
- Retrieve and prepare Dovetail/Omni-C paired-end reads for scaffolding
- Evaluate assembly quality
- Scaffold the assembly using Dovetail/Omni-C data


## Species information

**Species:** *Elgaria multicarinata*  
**Common name:** Southern alligator lizard  
**BioProject:** PRJNA808337  
**Specimen:** rElgMul1

---

## PacBio HiFi reads

PacBio HiFi reads for specimen `rElgMul1` were obtained from GenomeArk's public Amazon S3 bucket.

These long reads will be used for the initial de novo genome assembly.

### Data source

GenomeArk S3 directory:

https://genomeark.s3.amazonaws.com/index.html?prefix=species/Elgaria_multicarinata/rElgMul1/genomic_data/pacbio_hifi/

### Download

The PacBio HiFi files were downloaded recursively from GenomeArk using the AWS.

```bash
module load aws

aws s3 cp \
    s3://genomeark/species/Elgaria_multicarinata/rElgMul1/genomic_data/pacbio_hifi/ \
    /data/Wilson_Lab/projects/Group_Genome_Assembly/Elgaria_multicarinata/raw_reads/ \
    --recursive \
    --no-sign-request
```

Downloaded PacBio HiFi file:

```text
SRR19179400.hifi_reads.fastq.gz
```

AWS version:

```text
aws/2.15.26
```

---

## Dovetail / Omni-C sequencing data

Two paired-end SRA runs were downloaded using the NCBI SRA Toolkit for downstream genome scaffolding:

```text
SRR19179398
SRR19179399
```

### SRA Toolkit

The SRA Toolkit module used on Biowulf was:

```bash
module load sratoolkit/3.4.0
```

Because this Biowulf module requires local scratch space, jobs were run with `/lscratch` allocated through Slurm.


### Downloading the SRA runs
See download.dovetail.sh

The two SRA runs were retrieved with prefetch

Each run was then converted into paired-end FASTQ files using `fasterq-dump`.


Final files:

```text
SRR19179398_R1.fastq.gz
SRR19179398_R2.fastq.gz
SRR19179399_R1.fastq.gz
SRR19179399_R2.fastq.gz
```

---

## Read-count validation + Concat

| SRA run | R1 reads | R2 reads |
|---|---:|---:|
| SRR19179398 | 125,302,641 | 125,302,641 |
| SRR19179399 | 128,222,089 | 128,222,089 |

Total number of read pairs across both runs:

```text
253,524,730
```

Combining Dovetail / Omni-C runs

These were two runs of the same library for the same sample. The two SRA runs were combined so that scaffolding can be done with a single R1 file and a single R2 file.


R1 files were concatenated with:

```bash
cat \
    SRR19179398_R1.fastq.gz \
    SRR19179399_R1.fastq.gz \
    > Elgaria_dovetail_R1.fastq.gz
```

R2 files were concatenated with:

```bash
cat \
    SRR19179398_R2.fastq.gz \
    SRR19179399_R2.fastq.gz \
    > Elgaria_dovetail_R2.fastq.gz
```

Each combined file contains:

```text
253,524,730 reads
```

Combined files:

```text
Elgaria_dovetail_R1.fastq.gz
Elgaria_dovetail_R2.fastq.gz
```

The original SRA-specific FASTQ files are being retained for now.

---

## Directory structure

Current project organization:

```text
Elgaria_multicarinata/
├── raw_reads/
│   └── SRR19179400.hifi_reads.fastq.gz
├── dovetail/
│   ├── SRR19179398_R1.fastq.gz
│   ├── SRR19179398_R2.fastq.gz
│   ├── SRR19179399_R1.fastq.gz
│   ├── SRR19179399_R2.fastq.gz
│   ├── Elgaria_dovetail_R1.fastq.gz
│   └── Elgaria_dovetail_R2.fastq.gz
└── readme.txt
```

---

## Data summary

| Data | Source | Purpose |
|---|---|---|
| PacBio HiFi | GenomeArk / AWS S3 | Initial de novo genome assembly |
| SRR19179398 | NCBI SRA | Dovetail/Omni-C scaffolding |
| SRR19179399 | NCBI SRA | Dovetail/Omni-C scaffolding |

---

## Next steps

- Perform QC of the PacBio HiFi data
- Perform long-read genome assembly
- Evaluate assembly quality
- Use the combined Dovetail/Omni-C reads for scaffolding
- Evaluate the scaffolded assembly
- Document software, parameters, and outputs for each stage
