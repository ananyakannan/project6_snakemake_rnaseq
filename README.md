# Project 6 — Snakemake RNA-seq Pipeline

Reimplementing Project 5's manual RNA-seq pipeline (FastQC → fastp → HISAT2 → samtools → featureCounts) as an automated Snakemake workflow.

## Status: Day 1 complete

- Set up project folder structure (`raw_data/`, `results/`)
- Installed Snakemake (v6.1.2) into the existing `rnaseq` conda environment
- Wrote first two Snakemake rules: `fastqc_raw` and `fastqc_raw_r2`, running FastQC on one sample's paired-end reads (HBR_Rep1, chr22-only)
- Learned: rule structure (input/output/shell), how Snakemake builds its job DAG from a target file, and how to run individual targets from the command line

## Status: Day 2 complete

- Replaced two hardcoded FastQC rules with one generalized rule using two wildcards (`{sample}`, `{read}`)
- Added a `SAMPLES` list and `READS` list, and used `expand()` inside `rule all` to generate all 12 target files (6 samples x 2 reads) from those lists
- Ran the full FastQC step for all 6 samples with a single command: `snakemake --cores 1`
- Learned: wildcards, multi-wildcard rules, `rule all` as the default target, and `expand()` for generating file lists
- Confirmed Snakemake's smart rerun behavior: already-completed outputs were skipped automatically

## Next (Day 3)
- Add the fastp rule (trimming), chaining its input to the raw fastq files and producing two paired outputs (R1/R2 trimmed)

