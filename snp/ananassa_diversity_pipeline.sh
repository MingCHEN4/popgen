#!/bin/bash
scripts=/home/sobczm/bin/popgen/snp
input=/home/sobczm/popgen/snp/snp_chip/diversity
input_file=master_list_191917.txt
cd $input 
#This pipeline is only for F. ananassa without F. chiloensis and F. virginiana. After it is finished, re-run including F. chiloensis and viriginiana samples in directory: diversity_withWT #input_file=master_list_191917_withWT.txt
#Select sample ids of individuals to be included in the analysis and extract their
#genotypes from the db. 
#Goal - create 3 datasets:
#A) istraw35 samples only
#B) istraw90 samples only
#C) joint analysis of istraw35 and istraw90 samples - use intersection of istraw35 and istraw90 markers
qsub $scripts/sub_ananassa_genotypes_db.sh $input_file ${input_file}.out

#Separate GWAS dataset by plate type (datasets A) and B) above)
awk -F"\t" '$4 == "istraw90" { print $0 }' ${input_file}.out  OFS='\t' >${input_file}_istraw90.out
awk -F"\t" '$4 == "istraw35" { print $0 }' ${input_file}.out  OFS='\t' >${input_file}_istraw35.out

#Save a copy of sample table for reference in scripts.
a="SELECT id, clone_id, file, path, type, batch FROM sample"
echo $a | mysql -u marias -h mongo -D strawberry_samples -p$(cat /home/sobczm/bin/mysql_sample_database/login) >sample.txt

#In cases where sample ids belong to the same cultivar (clone), will select the sample with the most genotypes.
for infile in ${input_file}.out ${input_file}_istraw35.out ${input_file}_istraw90.out
do
python $scripts/eliminate_duplicate_clones.py sample.txt $infile >${infile%.out}.lst
done

#Now need to re-run the sub_ananassa_genotypes_db.sh script to obtain genotypes
for infile in ${input_file}.lst ${input_file}_istraw35.lst ${input_file}_istraw90.lst
do
qsub $scripts/sub_ananassa_genotypes_db.sh $infile ${infile%.lst}.out
done

#Convert the resulting files to VCF format to be used in PLINK and TASSEL.
#Have a choice of 3 GFF files for SNP assignment to the position on the chromosome.
#A) vesca genome ver. 1.1 $input/istraw90_vesca_v1.1_snp_positions.gff3
#B) vesca genome ver. 2.0 $input/istraw90_vesca_v2.0_snp_positions.gff3
#C) ananassa genome $input/vesca2consensus_map_noambiguous_2017-08-22.gff --> assignment of positions of significantly fewer number of markers than in vesca.

#Need to check back with Rob to get the latest version of those GFF files, as he's working
#on improving them. 

#Here, using B) and C)
gff_file=istraw90_vesca_v2.0_snp_positions.gff3
for infile in ${input_file}.out ${input_file}_istraw35.out ${input_file}_istraw90.out
do
qsub $scripts/sub_ananassa_genotypes_vcf.sh $infile $gff_file
done
mkdir vesca2.0
mv *.vcf vesca2.0

gff_file=vesca2consensus_map_noambiguous_2017-08-22.gff
for infile in ${input_file}.out ${input_file}_istraw35.out ${input_file}_istraw90.out
do
qsub $scripts/sub_ananassa_genotypes_vcf.sh $infile $gff_file
done
mkdir ananassa
mv *.vcf ananassa

#First, plink does not allow chromosome names to start with a letter, so fix that, and sort by coordinates.
for infile in vesca2.0/${input_file}.out.vcf vesca2.0/${input_file}_istraw35.out.vcf vesca2.0/${input_file}_istraw90.out.vcf ananassa/${input_file}.out.vcf ananassa/${input_file}_istraw35.out.vcf ananassa/${input_file}_istraw90.out.vcf
do
cat $infile | sed 's/LG//' | sed 's/Unknown/0/' | awk 'NR<3{print $0;next}{print $0| "sort -k1,2"}'  >${infile%.vcf}_fix.vcf
done

#Convert VCF to plink format.
#Log messages output by plink are useful and captured here, as they give info such as genotyping rate and number of variants/individuals before and after filtering.
for infile in vesca2.0/${input_file}.out_fix.vcf vesca2.0/${input_file}_istraw35.out_fix.vcf vesca2.0/${input_file}_istraw90.out_fix.vcf ananassa/${input_file}.out_fix.vcf ananassa/${input_file}_istraw35.out_fix.vcf ananassa/${input_file}_istraw90.out_fix.vcf
do
plink --allow-extra-chr --vcf $infile --recode --make-bed --out ${infile%.vcf} >${infile}.log
done

#Identification of individuals with elevated missing data rates or outlying heterozygosity rate
for infile in vesca2.0/${input_file}.out_fix vesca2.0/${input_file}_istraw35.out_fix  vesca2.0/${input_file}_istraw90.out_fix ananassa/${input_file}.out_fix ananassa/${input_file}_istraw35.out_fix ananassa/${input_file}_istraw90.out_fix
do
    plink --bfile ${infile} --missing --allow-extra-chr --out ${infile}  >${infile}_post_filtering.log
    plink --bfile ${infile} --het --allow-extra-chr --out ${infile}
done

#This reates files with extension ".het", in which the third column denotes the observed number of homozygous genotypes [O(Hom)] and the fifth column denotes the number of nonmissing genotypes [N(NM)] per individual.
#The script below calculates the observed heterozygosity rate per individual using the formula (N(NM) − O(Hom))/N(NM). It then creates a graph in which the observed heterozygosity rate per individual is plotted on the x axis and the proportion of missing SNPs per individuals is plotted on the y axis. The data underlying the graph which can be used to identify the outlier samples is written to file with extension "miss_het.txt"
#*Note* This script requires "geneplotter" and "tools" R libraries to be installed in your account. 
for infile in vesca2.0/${input_file}.out_fix vesca2.0/${input_file}_istraw35.out_fix  vesca2.0/${input_file}_istraw90.out_fix ananassa/${input_file}.out_fix ananassa/${input_file}_istraw35.out_fix ananassa/${input_file}_istraw90.out_fix
do
    Rscript --vanilla $scripts/imiss-vs-het.Rscript ${infile}
done

#Sample 474 (Dover) appears to show dramatically  high He rates, and as such will be removed as likely mis-labeled. 
echo '474 474' >>to_remove.txt

#Now, filter select individuals from the analysis (here only sample 474 - Dover).
for infile in vesca2.0/${input_file}.out_fix vesca2.0/${input_file}_istraw35.out_fix  vesca2.0/${input_file}_istraw90.out_fix ananassa/${input_file}.out_fix ananassa/${input_file}_istraw35.out_fix ananassa/${input_file}_istraw90.out_fix
do
    plink --bfile ${infile} --remove to_remove.txt --allow-extra-chr --make-bed --out ${infile}_filtered1 >${infile}.log
done

#Calculate the missing genotype rate for each marker. The results of this analysis can be found in files with ".lmiss" extension. 
for infile in vesca2.0/${input_file}.out_fix_filtered1 vesca2.0/${input_file}_istraw35.out_fix_filtered1  vesca2.0/${input_file}_istraw90.out_fix_filtered1 ananassa/${input_file}.out_fix_filtered1 ananassa/${input_file}_istraw35.out_fix_filtered1 ananassa/${input_file}_istraw90.out_fix_filtered1
do
plink --bfile $infile --missing --allow-extra-chr --out ${infile%.ped} >${infile%.ped}.log
done

#Plot a histogram of the missing genotype rate to identify a threshold for extreme genotype failure rate. This can be carried out using the data in column 5 of the .lmiss file.
#But first, convert weird spacing between columns to tabs in PLINK output, as before.
for infile in vesca2.0/${input_file}.out_fix_filtered1 vesca2.0/${input_file}_istraw35.out_fix_filtered1  vesca2.0/${input_file}_istraw90.out_fix_filtered1 ananassa/${input_file}.out_fix_filtered1 ananassa/${input_file}_istraw35.out_fix_filtered1 ananassa/${input_file}_istraw90.out_fix_filtered1
do
cat ${infile}.lmiss | awk '{$1=$1;print}' OFS='\t' >temp
mv temp ${infile}.lmiss 
Rscript --vanilla $scripts/plot_missing_genotypes_plink.R ${infile}.lmiss
done

#Remove SNPs with more than a given % of missing data. Here, 0%, 1%, 5%, 10% and 20%. Need to convert to PLINK's BAM format at this point to run the command.
for infile in vesca2.0/${input_file}.out_fix_filtered1 vesca2.0/${input_file}_istraw35.out_fix_filtered1  vesca2.0/${input_file}_istraw90.out_fix_filtered1 ananassa/${input_file}.out_fix_filtered1 ananassa/${input_file}_istraw35.out_fix_filtered1 ananassa/${input_file}_istraw90.out_fix_filtered1
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
    plink --bfile $infile --allow-extra-chr --geno $per_missing --make-bed --out ${infile}_${per_missing} >${infile}_${per_missing}.log
done
done

#*From this point onwards, using only the subsets filtered for markers with low genotyping rates.*

#In some cases, may be useful to calculate pairwise identity-by-descent (IBS - "DST" in the table output below) and PI_HAT (measure of identity-by-descent, but estimates only reliable using a big sample of individuals - not reliable here). We may then want to eliminate samples which are too closely related. As we have few samples and a lot of cultivars are inherently derived from a limited genetic pool, 
for infile in vesca2.0/${input_file}.out_fix_filtered1 vesca2.0/${input_file}_istraw35.out_fix_filtered1  vesca2.0/${input_file}_istraw90.out_fix_filtered1 ananassa/${input_file}.out_fix_filtered1 ananassa/${input_file}_istraw35.out_fix_filtered1 ananassa/${input_file}_istraw90.out_fix_filtered1
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
    plink --bfile ${infile}_${per_missing} --allow-extra-chr --genome --out ${infile}_${per_missing}
done
done

#However, in certain cases we may want to filter our closely related individuals in a pair above a certain IBS threshold. 
#The code below looks at the individual call rates and outputs the IDs of the individual with the lowest call rate for subsequent removal, if desired.
threshold=0.90
for infile in vesca2.0/${input_file}.out_fix_filtered1 vesca2.0/${input_file}_istraw35.out_fix_filtered1  vesca2.0/${input_file}_istraw90.out_fix_filtered1 ananassa/${input_file}.out_fix_filtered1 ananassa/${input_file}_istraw35.out_fix_filtered1 ananassa/${input_file}_istraw90.out_fix_filtered1
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
    plink --bfile ${infile}_${per_missing} --missing --allow-extra-chr --out ${infile}_${per_missing}  >${infile}_post_filtering.log
    perl $scripts/run-IBS-QC.pl ${infile}_${per_missing} $threshold > ${infile}_${per_missing}_to_filter
done
done

#Now, filter select individuals from the analysis (here samples related above 90% level by IBS).
for infile in vesca2.0/${input_file}.out_fix_filtered1 vesca2.0/${input_file}_istraw35.out_fix_filtered1  vesca2.0/${input_file}_istraw90.out_fix_filtered1 ananassa/${input_file}.out_fix_filtered1 ananassa/${input_file}_istraw35.out_fix_filtered1 ananassa/${input_file}_istraw90.out_fix_filtered1
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
    plink --bfile ${infile}_${per_missing} --allow-extra-chr --remove ${infile}_${per_missing}_to_filter --make-bed --out ${infile}_${per_missing}_filtered2 >${infile}_${per_missing}.log
done
done

#To estimate population stratification, PLINK offers tools to cluster individuals into homogeneous subsets (which is achieved through complete linkage agglomerative clustering based on pair-wise IBS distance) and to perform classical MDS to visualize substructure and provide quantitative indices of population genetic variation that can be used as covariates in subsequent association analysis to control for stratification, instead of using discrete clusters.
for infile in vesca2.0/${input_file}.out_fix_filtered1 vesca2.0/${input_file}_istraw35.out_fix_filtered1  vesca2.0/${input_file}_istraw90.out_fix_filtered1 ananassa/${input_file}.out_fix_filtered1 ananassa/${input_file}_istraw35.out_fix_filtered1 ananassa/${input_file}_istraw90.out_fix_filtered1
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
    plink --bfile ${infile}_${per_missing}_filtered2 --allow-extra-chr --genome --out ${infile}_${per_missing}_filtered2 
    plink --bfile ${infile}_${per_missing}_filtered2 --allow-extra-chr --read-genome ${infile}_${per_missing}_filtered2.genome --cluster --mds-plot 4 --silent --out ${infile}_${per_missing}_filtered2
done
done

#Convert weird spacing between columns to tabs in PLINK output 
for infile in vesca2.0/${input_file}.out_fix_filtered1 vesca2.0/${input_file}_istraw35.out_fix_filtered1  vesca2.0/${input_file}_istraw90.out_fix_filtered1 ananassa/${input_file}.out_fix_filtered1 ananassa/${input_file}_istraw35.out_fix_filtered1 ananassa/${input_file}_istraw90.out_fix_filtered1
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
    cat ${infile}_${per_missing}_filtered2.mds | awk '{$1=$1;print}' OFS='\t' >temp
    mv temp  ${infile}_${per_missing}_filtered2.mds 
done
done

#MDS plot based on Dimensions 1 and 2. 
#*Note*  Plotting requires R libraries "ggplot2", ""ggrepel" to be installed.
for infile in vesca2.0/${input_file}.out_fix_filtered1 vesca2.0/${input_file}_istraw35.out_fix_filtered1  vesca2.0/${input_file}_istraw90.out_fix_filtered1 ananassa/${input_file}.out_fix_filtered1 ananassa/${input_file}_istraw35.out_fix_filtered1 ananassa/${input_file}_istraw90.out_fix_filtered1
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
    Rscript --vanilla $scripts/plot_plink_mds.R ${infile}_${per_missing}_filtered2.mds
done
done

#Convert the filtered input files used in Plink to VCF so that can be used in other programs.
for infile in vesca2.0/${input_file}.out_fix_filtered1 vesca2.0/${input_file}_istraw35.out_fix_filtered1  vesca2.0/${input_file}_istraw90.out_fix_filtered1 ananassa/${input_file}.out_fix_filtered1 ananassa/${input_file}_istraw35.out_fix_filtered1 ananassa/${input_file}_istraw90.out_fix_filtered1
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
plink --bfile ${infile}_${per_missing}_filtered2 --allow-extra-chr --recode vcf-iid --out ${infile}_${per_missing}_filtered2
done
done

#Optional: seperate out the results for different filtering options used (one combination - one subdirectory)
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
    mkdir -p ${infile}/${per_missing}
    mv ${infile}*${per_missing}* ${infile}/${per_missing}
done
done 

#Split the VCF file by chromomsome.
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
my_infile=$(basename $infile)
vcf=${my_infile}_fix_filtered1_${per_missing}_filtered2.vcf
java -jar /home/sobczm/bin/snpEff/SnpSift.jar split ${infile}/${per_missing}/${vcf}
done
done

#Calculate the nucleotide diversity by chromosome.
vcftools=/home/sobczm/bin/vcftools/bin
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
for vcf in *.vcf
do
    $vcftools/vcftools --vcf $vcf --site-pi --out ${vcf%.vcf}.pi
done
cd $input
done
done

#Calculate summary statistics
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
for pi in *.pi
do
    Rscript --vanilla $scripts/summary_distribution.R $pi
done
cd $input
done
done

#Collect the results per chromosome in one file.
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
my_infile=$(basename $infile)
rm ${my_infile}_fix_filtered1_${per_missing}_filtered2.all.stats
echo "Chrom Min.  1st_Qu. Median  Mean    3rd_Qu. Max." >>${my_infile}_fix_filtered1_${per_missing}_filtered2.all.stats
for number in 1 2 3 4 5 5 7
do
    for letter in A B C D
    do
        current=${my_infile}_fix_filtered1_${per_missing}_filtered2.${number}${letter}.pi.sites.stat 
        echo -e "${number}${letter}\t\c" >>${my_infile}_fix_filtered1_${per_missing}_filtered2.all.stats
        cat $current >>${my_infile}_fix_filtered1_${per_missing}_filtered2.all.stats
    done
done
#Convert spaces to tabs
cat ${my_infile}_fix_filtered1_${per_missing}_filtered2.all.stats | awk '{$1=$1;print}' OFS='\t' >temp
mv temp ${my_infile}_fix_filtered1_${per_missing}_filtered2.all.stats 
cd $input
done
done

#Plot the distributions using boxplots
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
for pi in *.all.stats
do
    Rscript --vanilla $scripts/pi_boxplot_chrom.R $pi
done
cd $input
done
done

#Add cultivar names to VCF header.
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
for vcf in *.vcf
do
    python $scripts/vcf_append_cultivar.py $input/MASTER_Strawberry_List_19_10_17_sample_names.txt $vcf >temp
    mv temp $vcf
done
cd $input
done
done

#Calculate heterozygosity by chromosome.
vcftools=/home/sobczm/bin/vcftools/bin
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
for vcf in *.vcf
do
    $vcftools/vcftools --vcf $vcf --het --out ${vcf%.vcf}.het
done
cd $input
done
done

#Plot heterozygosity by sample.
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
for het in *.het
do
    Rscript --vanilla $scripts/heterozygosity_plot.R $het
done
cd $input
done
done

#Calculate pi by chromosome in 1 Mbp windows 
vcftools=/home/sobczm/bin/vcftools/bin
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
for vcf in *.vcf
do
    $vcftools/vcftools --vcf $vcf --window-pi 1000000 --window-pi-step 200000 --out ${vcf%.vcf}
done
cd $input
done
done

#Plot pi by chromosome in 1 Mbp windows 
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
for window in *.windowed.pi
do
    Rscript --vanilla $scripts/pi_plot_sliding_window_vcftools.R $window
done
cd $input
done
done

#Plot PCA
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
my_infile=$(basename $infile)
vcf=${my_infile}_fix_filtered1_${per_missing}_filtered2.vcf
Rscript --vanilla $scripts/pca_big.R $vcf
cd $input
done
done

#Plot NJ
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 
do
cd ${infile}/${per_missing}
my_infile=$(basename $infile)
vcf=${my_infile}_fix_filtered1_${per_missing}_filtered2.vcf
$scripts/nj_tree_big.sh master_list_191917.txt.out_fix_filtered1_0_filtered2.vcf 2
cd $input
done
done

#Plot heatmap distance matrix
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
cd ${infile}/0
my_infile=$(basename $infile)
vcf=${my_infile}_fix_filtered1_0_filtered2.vcf
$scripts/similarity_percentage.py $vcf
Rscript --vanilla $scripts/distance_matrix.R ${vcf%.vcf}_distance.log 50 50
cd $input
done

#fastStructure analysis
s=1
f=20
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out vesca2.0/${input_file}_istraw90.out 
do
for per_missing in 0 0.1 
do
cd ${infile}/${per_missing}
my_infile=$(basename $infile)
vcf=${my_infile}_fix_filtered1_${per_missing}_filtered2.vcf
mkdir fast_structure
cp $vcf fast_structure
cd fast_structure
plink --allow-extra-chr --const-fid 0 --vcf $vcf --recode --make-bed --out ${vcf%.vcf} >${vcf%.vcf}.log
for i in $(seq $s $f) #input range of K values tested
do
    qsub $scripts/sub_fast_structure.sh ${vcf%.vcf} $i
done
cd $input
done
done

#Parse the results to obtain optimal K values and produce Distruct-like plots.
structure=/home/sobczm/bin/fastStructure
s=1 #minimum number of considered clusters
f=20 #maximum number of considered clusters
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out vesca2.0/${input_file}_istraw90.out 
do
for per_missing in 0 0.1 
do
cd ${infile}/${per_missing}/fast_structure
my_infile=$(basename $infile)
vcf=${my_infile}_fix_filtered1_${per_missing}_filtered2.vcf
python $structure/chooseK.py --input=${vcf%.vcf} >${vcf%.vcf}_K_choice
cut -f2 ${vcf%.vcf}.fam | cut -d" " -f2 >${vcf%.vcf}.lab
for i in $(seq $s $f)
do 
    python $structure/distruct_mod.py -K $i --input=${vcf%.vcf} --output=${vcf%.vcf}_${i}.svg --title K$i --popfile=${vcf%.vcf}.lab
done
cd $input
done
done

#Convert all PDFs to PNG.
for infile in vesca2.0/${input_file}.out vesca2.0/${input_file}_istraw35.out  vesca2.0/${input_file}_istraw90.out ananassa/${input_file}.out ananassa/${input_file}_istraw35.out ananassa/${input_file}_istraw90.out
do
for per_missing in 0 0.01 0.05 0.1 0.2
do
cd ${infile}/${per_missing}
for my_pdf in *.pdf
do
    convert -verbose -density 500 "${my_pdf}" "${my_pdf%.*}.png"
done
cd ${infile}/${per_missing}/fast_structure
for my_pdf in *.pdf
do
    convert -verbose -density 500 "${my_pdf}" "${my_pdf%.*}.png"
done
cd $input
done
done