# QC Stages

## 1. FastQC + MultiQC

Run FastQC on each FASTQ file to assess read quality, then combine the FastQC outputs with MultiQC.

Scripts:

```text
run_fastqc_multiqc.sh
```

Main output:

```text
qc/multiqc/Elgaria_multicarinata_multiqc.html
```

HiFi QC results:
Reads: 5,443,717
Total sequence: 82.35 Gb
Mean read length: ~15.1 kb
Read N50: ~15.3 kb
GC content: ~43.5%
Q20 bases: 98%
Q30 bases: 96%


---

## 2. SeqKit statistics

Run SeqKit on the FASTQ files to summarize read counts, total sequence length, read length statistics, GC content, and quality metrics.

Script:

```text
seqkit_stats.sh
```

Main output:

```text
qc/seqkit/seqkit_stats.tsv
```

---

## 3. Jellyfish + GenomeScope

Run Jellyfish on the PacBio HiFi reads to count canonical 21-mers and generate a k-mer frequency histogram.

Script:

```text
jellyfish_kmer.sh
```

Main output:

```text
qc/kmer/Elgaria_k21.histo
```

Upload the Jellyfish histogram to GenomeScope 2.0:

http://genomescope.org/genomescope2.0/

Settings used:

```text
k = 21
ploidy = 2
```

GenomeScope was used to estimate genome size, heterozygosity, repeat content, and k-mer coverage.
GenomeScope estimates:
Haploid genome size: ~1.753 Gb
Heterozygosity: ~0.78%
Unique sequence: ~70.5%
Repetitive sequence: ~29.5%
Read error rate: ~0.165%


## 4. Coverage 

The k-mer spectrum contained an ~22.5× heterozygous peak and ~45× homozygous peak.

Using the GenomeScope genome-size estimate:
82.35 Gb HiFi sequence from SeqKit / 1.753 Gb genome ≈ 47× coverage

As an external check, the existing ~1.79-Gb reference assembly would give a similar estimate of approximately 46×.


