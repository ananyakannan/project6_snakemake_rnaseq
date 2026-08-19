SAMPLES = ["HBR_Rep1_ERCC-Mix2", "HBR_Rep2_ERCC-Mix2", "HBR_Rep3_ERCC-Mix2",
           "UHR_Rep1_ERCC-Mix1", "UHR_Rep2_ERCC-Mix1", "UHR_Rep3_ERCC-Mix1"]
READS = ["read1", "read2"]
rule all:
    input:
        expand("results/fastqc/{sample}_Build37-ErccTranscripts-chr22.{read}_fastqc.html", sample=SAMPLES, read=READS),
        expand("results/trimmed/{sample}_read1.trimmed.fastq.gz", sample=SAMPLES),
        expand("results/trimmed/{sample}_read2.trimmed.fastq.gz", sample=SAMPLES)
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
