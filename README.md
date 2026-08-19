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

## Status: Day 4 complete

- Added `hisat2_align` rule: chains onto `fastp_trim`'s output (trimmed R1/R2), aligns against the chr22 HISAT2 index, produces a `.sam` file per sample
- Learned: `params:` section — for values a rule needs (like a shared reference index prefix) that aren't tracked files themselves, referenced in `shell:` via `{params.name}`
- Confirmed a 3-rule chain now works end-to-end: raw fastq -> trimmed fastq -> aligned SAM, all driven by one `snakemake --cores 1` command
- Real alignment stats confirmed pipeline correctness (99.95% overall alignment rate on test sample)

## Status: Day 5 complete

- Added `samtools_sort` rule: converts each sample's SAM into a sorted BAM
- Added `samtools_index` rule: creates the `.bai` index alongside the sorted BAM
- Wrote both rules independently (samtools commands already known from Project 5), correctly using colons after rule names and quoted shell strings
- Confirmed automatic multi-step chaining: requesting only the final `.bai` file triggered both `samtools_sort` and `samtools_index` to run in the correct order
- Full pipeline (5 rules deep) now runs end-to-end for all 6 samples with one command

## Status: Day 6 complete

- Added `feature_counts` rule — the first many-to-one rule in the pipeline: input is all 6 sorted BAMs (via `expand()`), output is one single count matrix, no per-sample wildcard in the output
- Learned: how a rule's shape changes when going from one-to-one to many-to-one — `expand()` inside `input:` produces a full file list, and `output:`/`shell:` operate on that whole set in a single execution rather than per-sample
- Confirmed via the job log that featureCounts ran exactly once (not once per sample), using all 6 BAMs together
- Verified output: gene x sample count matrix (`gene_counts.txt`) and sanity-checked assignment stats in `gene_counts.txt.summary` across all 6 samples

## Next (Day 7)
- Add `rule all` cleanup, visualize the DAG, and introduce config.yaml to move sample names/paths out of the Snakefile





