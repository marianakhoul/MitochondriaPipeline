### Based on WDL script in: https://portal.firecloud.org/?return=terra#methods/cricker/vcf2maf_CR/


import os

configfile: "config/config.yaml"
configfile: "config/samples.yaml"

rule all:
    input:
         expand("results/vcf2maf/{tumor}.vcf", tumor=config["pairings"])
         
         
rule vcf2maf:
    input:
        tumor_vcf = results/SplitMultiAllelicSites/{tumor}.vcf,
        normal_vcf = results/SplitMultiAllelicSites/{normal}.vcf
    output:
        maf = "results/SubsetBamtoChrM/{tumor}.maf"
    params:
        gatk = config["gatk_path"],
        contig_name = config["contig_name"]
    log:
        "logs/SubsetBamtoChrM/{tumor}.txt"
    shell:
        "({params.gatk} PrintReads \
        -L {params.contig_name} \
        --read-filter MateOnSameContigOrNoMappedMateReadFilter \
        --read-filter MateUnmappedAndUnmappedReadFilter \
        -I {input.tumor_filepath} \
        -O {output.bam}) 2> {log}"
