#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe smp 16
#$ -l virtual_free=1.5G
#$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace|blacklace06.blacklace|blacklace07.blacklace|blacklace08.blacklace|blacklace09.blacklace|blacklace10.blacklace

input=$1
cpath=$PWD

temp_dir="$TMPDIR"
mkdir -p $temp_dir

cp -r $input $temp_dir
input_f=$(basename "$input")
cd $temp_dir

bayescan=/home/sobczm/bin/bayescan2.1/binaries/BayeScan2.1_linux64bits
$bayescan -threads 16 -od ./ $input_f

rm $input_f
cp -r * $cpath
rm -rf $temp_dir