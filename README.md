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

## Status: Day 3 complete

- Added `fastp_trim` rule: takes paired R1/R2 raw fastq as two named inputs, produces two named trimmed outputs in one command
- Learned: multi-input/multi-output rules using named entries (`r1 =`, `r2 =`), and that Python's comma-between-items syntax applies inside `input:`/`output:` blocks
- Learned: `rule all` has no `output`/`shell` — it's a wishlist of final targets that Snakemake works backward from
- Extended `rule all` to request trimmed outputs for all 6 samples via `expand()`
- Ran full pipeline (FastQC + fastp) for all 6 samples with one command: `snakemake --cores 1`

## Next (Day 4)
- Add the HISAT2 alignment rule, taking trimmed fastq as input and producing a BAM file


