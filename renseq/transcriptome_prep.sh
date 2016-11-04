#!/bin/bash
input=/home/sobczm/popgen/renseq/input
scripts=/home/sobczm/bin/popgen/renseq

#Align our reads to Fusarium genomes.
InsertGap='-20'
InsertStdDev='78'

##Fus2 genomes
Assembly=$input/reads/Fus2_canu_contigs_unmasked.fa

FileF=$input/reads/55_72hrs_rep1/F/*.gz
FileR=$input/reads/55_72hrs_rep1/R/*.gz
OutDir=$input/reads/55_72hrs_rep1/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/55_72hrs_rep2/F/*.gz
FileR=$input/reads/55_72hrs_rep2/R/*.gz
OutDir=$input/reads/55_72hrs_rep2/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/55_72hrs_rep3/F/*.gz
FileR=$input/reads/55_72hrs_rep3/R/*.gz
OutDir=$input/reads/55_72hrs_rep3/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/Fus2_72hrs_rep1/F/*.gz
FileR=$input/reads/Fus2_72hrs_rep1/R/*.gz
OutDir=$input/reads/Fus2_72hrs_rep1/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/Fus2_72hrs_rep2/F/*.gz
FileR=$input/reads/Fus2_72hrs_rep2/R/*.gz
OutDir=$input/reads/Fus2_72hrs_rep2/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/Fus2_72hrs_rep3/F/*.gz
FileR=$input/reads/Fus2_72hrs_rep3/R/*.gz
OutDir=$input/reads/Fus2_72hrs_rep3/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

#fo47 genomes
Assembly=$input/reads/fo47_contigs_unmasked.fa
FileF=$input/reads/FO47_72hrs_rep1/F/*.gz
FileR=$input/reads/FO47_72hrs_rep1/R/*.gz
OutDir=$input/reads/FO47_72hrs_rep1/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/FO47_72hrs_rep2/F/*.gz
FileR=$input/reads/FO47_72hrs_rep2/R/*.gz
OutDir=$input/reads/FO47_72hrs_rep2/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/FO47_72hrs_rep3/F/*.gz
FileR=$input/reads/FO47_72hrs_rep3/R/*.gz
OutDir=$input/reads/FO47_72hrs_rep3/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

#Extract reads not mapping to the pathogen genome, and therefore
#assumed to originate in onion
for a in ./*rep*
do
cd $a
qsub $popgen/sub_get_sorted_paired_reads.sh unmapped.bam accepted_hits.bam
rm -rf F R
cd ../
done

#Create a merged forward and reverse FASTQ file containing all the reads from
#the experiments
for a in ./*rep*
do
cd $a
cat r_sorted.fastq >> all_reads_r.fastq
cat f_sorted.fastq >> all_reads_f.fastq
cd ../
done

#Compress the remaining raw reads for storage
for a in ./*rep*
do
cd $a
tar -zcvf r_sorted.fastq.tar.gz r_sorted.fastq
tar -zcvf f_sorted.fastq.tar.gz f_sorted.fastq
cd ../
done

##Preliminary experiments
Assembly=$input/reads/Fus2_canu_contigs_unmasked.fa

FileF=$input/reads/prelim/Fus2_0hrs_prelim/F/*.gz
FileR=$input/reads/prelim/Fus2_0hrs_prelim/R/*.gz
OutDir=$input/prelim/reads/Fus2_0hrs_prelim/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/prelim/Fus2_16hrs_prelim/F/*.gz
FileR=$input/reads/prelim/Fus2_16hrs_prelim/R/*.gz
OutDir=$input/prelim/reads/Fus2_16hrs_prelim/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/prelim/Fus2_24hrs_prelim/F/*.gz
FileR=$input/reads/prelim/Fus2_24hrs_prelim/R/*.gz
OutDir=$input/prelim/reads/Fus2_24hrs_prelim/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/prelim/Fus2_36hrs_prelim/F/*.gz
FileR=$input/reads/prelim/Fus2_36hrs_prelim/R/*.gz
OutDir=$input/prelim/reads/Fus2_36hrs_prelim/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/prelim/Fus2_48hrs_prelim/F/*.gz
FileR=$input/reads/prelim/Fus2_48hrs_prelim/R/*.gz
OutDir=$input/prelim/reads/Fus2_48hrs_prelim/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/prelim/Fus2_4hrs_prelim/F/*.gz
FileR=$input/reads/prelim/Fus2_4hrs_prelim/R/*.gz
OutDir=$input/prelim/reads/Fus2_4hrs_prelim/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/prelim/Fus2_72hrs_prelim/F/*.gz
FileR=$input/reads/prelim/Fus2_72hrs_prelim/R/*.gz
OutDir=$input/prelim/reads/Fus2_72hrs_prelim/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/prelim/Fus2_8hrs_prelim/F/*.gz
FileR=$input/reads/prelim/Fus2_8hrs_prelim/R/*.gz
OutDir=$input/prelim/reads/Fus2_8hrs_prelim/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

FileF=$input/reads/prelim/Fus2_96hrs_prelim/F/*.gz
FileR=$input/reads/prelim/Fus2_96hrs_prelim/R/*.gz
OutDir=$input/prelim/reads/Fus2_96hrs_prelim/
qsub $scripts/sub_tophat_alignment.sh $Assembly $FileF $FileR $OutDir \
$InsertGap $InsertStdDev

#Extract reads not mapping to the pathogen genome, and therefore
#assumed to originate in onion
for a in ./prelim/*rep*
do
cd $a
qsub $popgen/sub_get_sorted_paired_reads.sh unmapped.bam accepted_hits.bam
rm -rf F R
cd ../
done

#Create a merged forward and reverse FASTQ file containing all the reads from
#the experiments
for a in ./prelim/*rep*
do
cd $a
cat r_sorted.fastq >> all_reads_r.fastq
cat f_sorted.fastq >> all_reads_f.fastq
cd ../
done

#Compress the remaining raw reads for storage
for a in ./prelim/*rep*
do
cd $a
tar -zcvf r_sorted.fastq.tar.gz r_sorted.fastq
tar -zcvf f_sorted.fastq.tar.gz f_sorted.fastq
cd ../
done

#Use RepeatMasker to mask repeat and low complexity regions in the transcriptomes.
#Transcriptomes from the literature
qsub $scripts/sub_repeat_masker.sh $input/transcriptomes/NZ/GBGJ01_1_fsa_nt_nz.fasta
qsub $scripts/sub_repeat_masker.sh $input/transcriptomes/RAJ/GBJZ01_1_fsa_nt_raj.fasta
qsub $scripts/sub_repeat_masker.sh $input/transcriptomes/KIM/GBRQ01_1_fsa_nt_combined_kim.fasta
#In-house transcriptomes
