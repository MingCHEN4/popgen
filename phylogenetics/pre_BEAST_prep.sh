#!/bin/bash
 
###Preparing alignments and finding best-fit nucleotide sequence evolution models

path=/home/sobczm/popgen
scripts=/home/sobczm/bin/scripts

##MAFFT (alignments)

cd $path/busco
mv *.fasta $path/busco_alignments 
cd $path/busco_alignments

for f in *.fasta; do qsub $scripts/sub_mafft_alignment.sh $f; done

## Identify genes with high nucleotide diversity

python $scripts/calculate_nucleotide_diversity.py "*aligned.fasta"

## Visually inspect the alignments of select genes to be used in constructing the phylogenies and trim them as necessary in MEGA6.
## Copy the relevant trimmed alignment FASTA files into $path/beast_runs

##PartitionFinder (nucleotide sequence evolution model)

config_template=/home/sobczm/bin/PartitionFinder1.1.1/fus.cfg
ct=$(basename "$config_template")

cd $path/beast_runs

# prepare directory for PartitionFinder run:
for f in *trimmed.fasta
do
c="$(cat $f | awk 'NR%2==0' | awk '{print length($1)}' | head -1)"
p="${f%.fasta}.phy"
n="${f%.fasta}.NEXUS"
dir="${f%_trimmed*}"

mkdir $dir
cp $config_template $dir
mv $dir/$config_template partition_finder.cfg

# Substitute the name of the alignment file and the sequence length in the config file to become correct for the current run.

sed -i 's,^\(alignment = \).*,\1'"$p;"',' $dir/$ct
sed -i 's,^\(Gene1_pos1 = \).*,\1'"1-$c\\\3;"',' $dir/$ct
sed -i 's,^\(Gene1_pos2 = \).*,\1'"2-$c\\\3;"',' $dir/$ct
sed -i 's,^\(Gene1_pos3 = \).*,\1'"3-$c\\\3;"',' $dir/$ct

# Convert FASTA to phylip for the Partition Finder run
$scripts/fasta2phylip.pl $f>$p
mv $p $dir 

# Convert FASTA to NEXUS for the BEAST run
$scripts/Fasta2Nexus.pl $f>$n

qsub $scripts/sub_partition_finder.sh $dir

done

