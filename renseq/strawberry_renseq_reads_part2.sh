#!/bin/bash
scripts=/home/sobczm/bin/popgen/renseq
input=/home/sobczm/files/Helen_Bates_EMR.RH.ENQ-1704.A.01

####Note: analysis carried out on NIAB's triticum.

###Trim Illumina adaptors from raw PacBio reads using a script from Giolai et al. (2016)
cd $input//Raw_reads_S1/F06_1/Analysis_Results
for a in *.bax.h5; do $scripts/trim-h5.py $a; done
cd $input//Raw_reads_S2/G06_1/Analysis_Results
for a in *.bax.h5; do $scripts/trim-h5.py $a; done

##Polish the RG Canu assembly with Pilon using Illumina reads,
# [Carried out on EMR cluster]
reads=/home/groups/harrisonlab/project_files/fragaria_x_ananassa/octoseq/PE
input2=/home/sobczm/popgen/renseq/strawberry/reads/Helen_Bates_EMR.RH.ENQ-1704.A.01
qsub $scripts/sub_pilon_3_libs.sh $input2/assembly/G06_assembly/G06.contigs.fasta $reads/1628_LIB19365_LDI16700_GCCAAT_L001_R1.fastq.gz $reads/1628_LIB19365_LDI16700_GCCAAT_L001_R2.fastq.gz $reads/1650_LIB19365_LDI16700_GCCAAT_L001_R1.fastq.gz $reads/1650_LIB19365_LDI16700_GCCAAT_L001_R2.fastq.gz $reads/1670_LIB19365_LDI16700_GCCAAT_L001_R1.fastq.gz $reads/1670_LIB19365_LDI16700_GCCAAT_L001_R2.fastq.gz 

#Get the following error from bowtie:
#Saw ASCII character 0 but expected 33-based Phred qual.
#terminate called after throwing an instance of 'int'
#Aborted (core dumped)
#(ERR): bowtie2-align exited with value 134
cd $input2/assembly/G06_assembly/
qsub $scripts/sub_pilon_3_libs.sh G06.contigs.fasta 1628_LIB19365_LDI16700_GCCAAT_L001_R1.fastq 1628_LIB19365_LDI16700_GCCAAT_L001_R2.fastq 1650_LIB19365_LDI16700_GCCAAT_L001_R1.fastq 1650_LIB19365_LDI16700_GCCAAT_L001_R2.fastq 1670_LIB19365_LDI16700_GCCAAT_L001_R1.fastq 1670_LIB19365_LDI16700_GCCAAT_L001_R2.fastq 
##But ASCII character 0 is @ which is within PHRED32.
##grepping for "M" or "d", one of the characters within PHRED64 brings no results. The file is clearly PHRED 32.

#Going to use bwa mem instead. Each library will be aligned separately and then merged with samtools merge.
qsub $scripts/sub_bwa_mem.sh Illumina 1628 G06.contigs.fasta 1628_LIB19365_LDI16700_GCCAAT_L001_R1.fastq 1628_LIB19365_LDI16700_GCCAAT_L001_R2.fastq 
#OK, now bwa mem complaining about not matching read names. Need to resort.
qsub $scripts/sub_pairfq.sh 1628_LIB19365_LDI16700_GCCAAT_L001_R1.fastq 1628_LIB19365_LDI16700_GCCAAT_L001_R2.fastq

#Assemble each cultivar with Falcon on triticum.
#For RedGauntlent, polish with Illumina reads using Canu.


#Carry out minor variant calling with PacBio minorseq pipeline
#using canu and Falcon polished assembly as reference.
