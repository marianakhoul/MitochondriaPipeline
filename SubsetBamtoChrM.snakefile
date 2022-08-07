import re

configfile: "config/config.yaml"
configfile: "config/samples.yaml"

rule all:
    input:
	expand("results/SubsetBamtoChrM/{sample}.bam", sample=config["samples"])

rule SubsetBamtoChrM:
    input:
    	tumor_filepath = lambda wildcards: config["samples"][wildcards.tumor],
	#normal_filepath = lambda wildcards: config["samples"][config["pairings"][wildcards.tumor]]
    output:
    	bam = protected("results/SubsetBamtoChrM/{tumor}.bam"),
	bai = protected("results/SubsetBamtoChrM/{tumor}.bai")
    params:
        gatk = config["gatk_path"],
	contig_name = config["contig_name"]
    log:
    	"logs/SubsetBamtoChrM/{tumor}.txt"
    shell:
    	"echo {input.tumor_filepath}"
    	#"({params.gatk} PrintReads \
      	#-L {params.contig_name} \
      	#--read-filter MateOnSameContigOrNoMappedMateReadFilter \
      	#--read-filter MateUnmappedAndUnmappedReadFilter \
      	#-I {input.tumor_filepath} \
      	#-O {output.bam}) 2> {log}"
	
