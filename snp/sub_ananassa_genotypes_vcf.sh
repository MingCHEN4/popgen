#$ -S /bin/bash
#$ -cwd
#$ -pe smp 1
#$ -l h_vmem=4G
#$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace|blacklace06.blacklace|blacklace07.blacklace|blacklace08.blacklace|blacklace09.blacklace|blacklace10.blacklace|blacklace11.blacklace
input1=$1
input2=$2

/home/sobczm/bin/popgen/snp/ananassa_genotypes_vcf.py $input1 $input2