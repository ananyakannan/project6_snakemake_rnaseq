SAMPLES = ["HBR_Rep1_ERCC-Mix2", "HBR_Rep2_ERCC-Mix2", "HBR_Rep3_ERCC-Mix2",
           "UHR_Rep1_ERCC-Mix1", "UHR_Rep2_ERCC-Mix1", "UHR_Rep3_ERCC-Mix1"]
READS = ["read1", "read2"]
rule all:
    input:
        expand("results/fastqc/{sample}_Build37-ErccTranscripts-chr22.{read}_fastqc.html", sample=SAMPLES, read=READS)
rule fastqc_raw:
    input:
        "raw_data/{sample}_Build37-ErccTranscripts-chr22.{read}.fastq.gz"
    output:
        "results/fastqc/{sample}_Build37-ErccTranscripts-chr22.{read}_fastqc.html"
    shell:
        "fastqc {input} -o results/fastqc/"
