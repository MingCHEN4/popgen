#!/bin/bash
input=/home/sobczm/popgen/renseq/input/transcriptomes
scripts=/home/sobczm/bin/popgen/renseq
#Additional tool to annotate non-canonical R genes not containing the NBS domain.
#Using it to annotate the following groups of candidate genes:
#RLK (transmembrane-LRR/LysM-STTK domain)
#RLP (transmembrane-LRR/LysM domain)
#TMCC (transmembrane-coiled coil)

cd $input
names=( "kim" "nz" "maria" "raj" "brian" "cornell" "h6" "han" "sp3b" "liu" "sun" )
for f in "${names[@]}"
do
fca=$(echo $f | tr '[:lower:]' '[:upper:]')
#Create a seperate directory structure
mkdir -p $input/rgaugury/$f
cp $input/$fca/onion_${f}_protein.fa $input/rgaugury/$f
#Remove stop-codons from six-frame translated contigs
sed -i 's/\*//g' $input/rgaugury/$f/onion_${f}_protein.fa
#Break down the files into smaller chunks and run rgaugury for each transcriptome.
#As this taking too long, going to parallelise in a crude way by splitting
#into small files with 100 protein sequences and running 20 at a time.
cd $input/rgaugury/$f
file=onion_${f}_protein.fa
awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' $file>temp && mv temp $file
awk 'BEGIN {n_seq=0;} /^>/ {if(n_seq%100==0){file=sprintf("myseq%d.fa",n_seq);} print >> file; n_seq++; next;} { print >> file; }' < $file
for file in myseq*.fa
do
    Jobs=$(qstat | grep 'sub_rgaugu' | wc -l)
    while [ $Jobs -gt 40 ]
    do
        sleep 10
        printf "."
        Jobs=$(qstat | grep 'sub_rgaugu' | wc -l)
    done
qsub $scripts/sub_rgaugury.sh $file
done
done



#Concatenate the output for RLK, RLP and TMCC genes.
names=( "nz" "cornell" "han" "liu" )
for name in "${names[@]}"
do
cd $input/rgaugury/$name
for f in *.TMCC.candidates.lst
    cat $f >> ${name}.TMCC.candidates.lst
done
for f in *.RLP.candidates.lst
do
    cat $f >> ${name}.RLP.candidates.lst
done
for f in *.RLK.candidates.lst
do
    cat $f >> ${name}.RLK.candidates.lst
done
for f in *.RGA.candidates.lst
do
    cat $f >> ${name}.RGA.candidates.lst
done
for f in *.RLKorRLP.merged.domains.txt
do
    lines=$(wc -l $f | cut -d" " -f1)
    if [ $lines > 1 ]; then
    sed -n 2,${lines}p $f >> ${name}.RLKorRLP.merged.domains.txt
    fi
done
for f in *.NBS.candidates.lst
do
    cat $f >> ${name}.NBS.candidates.lst
done
done

#Detect contigs containing two other domains
