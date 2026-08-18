rule fastqc_raw:
    input:
        "raw_data/HBR_Rep1_ERCC-Mix2_Build37-ErccTranscripts-chr22.read1.fastq.gz"
    output:
        "results/fastqc/HBR_Rep1_ERCC-Mix2_Build37-ErccTranscripts-chr22.read1_fastqc.html"
    shell:
        "fastqc {input} -o results/fastqc"
rule fastqc_raw_r2:
    input:
        "raw_data/HBR_Rep1_ERCC-Mix2_Build37-ErccTranscripts-chr22.read2.fastq.gz"
    output:
        "results/fastqc/HBR_Rep1_ERCC-Mix2_Build37-ErccTranscripts-chr22.read2_fastqc.html"
    shell:
        "fastqc {input} -o results/fastqc"
