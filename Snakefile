configfile: "config.yaml"
SAMPLES = config["samples"]
READS = config["reads"]
rule all:
    input:
        expand("results/fastqc/{sample}_Build37-ErccTranscripts-chr22.{read}_fastqc.html", sample=SAMPLES, read=READS),
        expand("results/trimmed/{sample}_read1.trimmed.fastq.gz", sample=SAMPLES),
        expand("results/trimmed/{sample}_read2.trimmed.fastq.gz", sample=SAMPLES),
        expand("results/aligned/{sample}.sam", sample=SAMPLES),
        expand("results/aligned/{sample}.sorted.bam.bai", sample=SAMPLES),
        "results/counts/gene_counts.txt"
rule fastqc_raw:
    input:
        "raw_data/{sample}_Build37-ErccTranscripts-chr22.{read}.fastq.gz"
    output:
        "results/fastqc/{sample}_Build37-ErccTranscripts-chr22.{read}_fastqc.html"
    shell:
        "fastqc {input} -o results/fastqc/"

rule fastp_trim:
    input: 
        r1 = "raw_data/{sample}_Build37-ErccTranscripts-chr22.read1.fastq.gz",
        r2 = "raw_data/{sample}_Build37-ErccTranscripts-chr22.read2.fastq.gz"
    output:
        r1 = "results/trimmed/{sample}_read1.trimmed.fastq.gz",
        r2 = "results/trimmed/{sample}_read2.trimmed.fastq.gz"
    shell:  
        "fastp -i {input.r1} -I {input.r2} -o {output.r1} -O {output.r2}"

rule hisat2_align:
    input:
        r1 = "results/trimmed/{sample}_read1.trimmed.fastq.gz",
        r2 = "results/trimmed/{sample}_read2.trimmed.fastq.gz"
    output:
        "results/aligned/{sample}.sam"
    params:
        index = config["hisat2_index"]
    shell:
        "hisat2 -x {params.index} -1 {input.r1} -2 {input.r2} -S {output}"

rule samtools_sort:
    input:
        "results/aligned/{sample}.sam"
    output: 
        "results/aligned/{sample}.sorted.bam"
    shell:
        "samtools sort {input} -o {output}"

rule samtools_index:
    input:
        "results/aligned/{sample}.sorted.bam"
    output:
        "results/aligned/{sample}.sorted.bam.bai"
    shell:
        "samtools index {input}"
rule feature_counts:
    input:
        expand("results/aligned/{sample}.sorted.bam", sample=SAMPLES)
    output:
        "results/counts/gene_counts.txt"
    params:
        gtf = config["gtf"]
    shell:
        "featureCounts -p -a {params.gtf} -o {output} {input}"
