mysql> SHOW tables;
+------------------------------+
| Tables_in_strawberry_samples |
+------------------------------+
| alias                        |
| clone                        |
| clone_tag                    |
| genotype                     |
| marker                       |
| pipeline_run                 |
| sample                       |
| sample_tag                   |
+------------------------------+
8 rows in set (0.00 sec)

mysql> DESCRIBE alias;
+-----------+------------+------+-----+---------+----------------+
| Field     | Type       | Null | Key | Default | Extra          |
+-----------+------------+------+-----+---------+----------------+
| id        | bigint(20) | NO   | PRI | NULL    | auto_increment |
| platform  | char(30)   | YES  |     | NULL    |                |
| probe_id  | char(30)   | YES  | MUL | NULL    |                |
| snp_id    | char(30)   | YES  |     | NULL    |                |
| marker_id | bigint(20) | YES  |     | NULL    |                |
+-----------+------------+------+-----+---------+----------------+
5 rows in set (0.00 sec)

mysql> DESCRIBE clone;
+--------+--------------+------+-----+---------+----------------+
| Field  | Type         | Null | Key | Default | Extra          |
+--------+--------------+------+-----+---------+----------------+
| id     | int(11)      | NO   | PRI | NULL    | auto_increment |
| name   | varchar(100) | YES  |     | NULL    |                |
| mat_id | int(11)      | YES  |     | NULL    |                |
| pat_id | int(11)      | YES  |     | NULL    |                |
+--------+--------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

mysql> DESCRIBE clone_tag;
+----------+--------------+------+-----+---------+-------+
| Field    | Type         | Null | Key | Default | Extra |
+----------+--------------+------+-----+---------+-------+
| clone_id | int(11)      | YES  |     | NULL    |       |
| tag      | varchar(100) | YES  |     | NULL    |       |
+----------+--------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

mysql> DESCRIBE genotype;
+-------------+------------+------+-----+---------+----------------+
| Field       | Type       | Null | Key | Default | Extra          |
+-------------+------------+------+-----+---------+----------------+
| id          | bigint(20) | NO   | PRI | NULL    | auto_increment |
| pipeline_id | int(11)    | YES  |     | NULL    |                |
| sample_id   | int(11)    | YES  |     | NULL    |                |
| alias_id    | bigint(20) | YES  |     | NULL    |                |
| clustering  | char(3)    | YES  |     | NULL    |                |
| genotype    | char(2)    | YES  |     | NULL    |                |
| haplotype   | char(2)    | YES  |     | NULL    |                |
+-------------+------------+------+-----+---------+----------------+
7 rows in set (0.00 sec)

mysql> DESCRIBE marker;
+----------+------------+------+-----+---------+----------------+
| Field    | Type       | Null | Key | Default | Extra          |
+----------+------------+------+-----+---------+----------------+
| id       | bigint(20) | NO   | PRI | NULL    | auto_increment |
| probe_id | char(30)   | YES  | UNI | NULL    |                |
| snp_id   | char(30)   | YES  | MUL | NULL    |                |
| alleles  | char(30)   | YES  |     | NULL    |                |
| strand   | char(5)    | YES  |     | NULL    |                |
| context  | char(100)  | YES  | MUL | NULL    |                |
+----------+------------+------+-----+---------+----------------+
6 rows in set (0.00 sec)

mysql> DESCRIBE pipeline_run;
+-------------+---------------+------+-----+---------+----------------+
| Field       | Type          | Null | Key | Default | Extra          |
+-------------+---------------+------+-----+---------+----------------+
| id          | int(11)       | NO   | PRI | NULL    | auto_increment |
| name        | char(50)      | YES  |     | NULL    |                |
| script_path | char(250)     | YES  |     | NULL    |                |
| data_path   | char(250)     | YES  |     | NULL    |                |
| date        | date          | YES  |     | NULL    |                |
| notes       | varchar(1000) | YES  |     | NULL    |                |
+-------------+---------------+------+-----+---------+----------------+
6 rows in set (0.00 sec)

mysql> DESCRIBE sample;
+----------+--------------+------+-----+---------+----------------+
| Field    | Type         | Null | Key | Default | Extra          |
+----------+--------------+------+-----+---------+----------------+
| id       | int(11)      | NO   | PRI | NULL    | auto_increment |
| clone_id | int(11)      | YES  |     | NULL    |                |
| file     | varchar(100) | YES  | MUL | NULL    |                |
| path     | varchar(200) | YES  |     | NULL    |                |
| type     | varchar(100) | YES  |     | NULL    |                |
| date     | date         | YES  |     | NULL    |                |
| batch    | varchar(100) | YES  |     | NULL    |                |
+----------+--------------+------+-----+---------+----------------+
7 rows in set (0.00 sec)

mysql> DESCRIBE sample_tag;
+-----------+--------------+------+-----+---------+-------+
| Field     | Type         | Null | Key | Default | Extra |
+-----------+--------------+------+-----+---------+-------+
| sample_id | int(11)      | YES  |     | NULL    |       |
| tag       | varchar(100) | YES  |     | NULL    |       |
+-----------+--------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

mysql> SELECT * FROM alias LIMIT 10;
+----+----------+-------------+---------------+-----------+
| id | platform | probe_id    | snp_id        | marker_id |
+----+----------+-------------+---------------+-----------+
|  1 | istraw90 | AX-89803679 | Affx-88819427 |         1 |
|  2 | istraw90 | AX-89804064 | Affx-88831685 |         2 |
|  3 | istraw90 | AX-89804316 | Affx-88832267 |         3 |
|  4 | istraw90 | AX-89805693 | Affx-88810467 |         4 |
|  5 | istraw90 | AX-89806602 | Affx-88819381 |         5 |
|  6 | istraw90 | AX-89779627 | Affx-88809314 |         6 |
|  7 | istraw90 | AX-89782268 | Affx-88819410 |         7 |
|  8 | istraw90 | AX-89782909 | Affx-88819426 |         8 |
|  9 | istraw90 | AX-89783470 | Affx-88819558 |         9 |
| 10 | istraw90 | AX-89783911 | Affx-88819697 |        10 |
+----+----------+-------------+---------------+-----------+
10 rows in set (0.00 sec)

mysql> SELECT * FROM clone LIMIT 10;
+----+-------------+--------+--------+
| id | name        | mat_id | pat_id |
+----+-------------+--------+--------+
|  1 | Redgauntlet |   NULL |   NULL |
|  2 | Hapil       |   NULL |   NULL |
|  3 | Emily       |   NULL |   NULL |
|  4 | Fenella     |   NULL |   NULL |
|  5 | Flamenco    |   NULL |   NULL |
|  6 | Chandler    |   NULL |   NULL |
|  7 | BSP14       |   NULL |   NULL |
|  8 | Elvira      |   NULL |   NULL |
|  9 | Camarosa    |   NULL |   NULL |
| 10 | Capitola    |   NULL |   NULL |
+----+-------------+--------+--------+
10 rows in set (0.00 sec)

mysql> SELECT COUNT(*) FROM clone;
+----------+
| COUNT(*) |
+----------+
|     1777 |
+----------+
1 row in set (0.00 sec)

#Export the table into a TAB file.

mysql> SELECT * FROM clone_tag LIMIT 10;
+----------+-------+
| clone_id | tag   |
+----------+-------+
|     3168 | rogue |
|     3169 | rogue |
|     3170 | rogue |
|     3171 | rogue |
|     3172 | rogue |
|     3173 | rogue |
|     3174 | rogue |
|     3175 | rogue |
|     3176 | rogue |
|     3177 | rogue |
+----------+-------+
10 rows in set (0.00 sec)

mysql> SELECT * FROM genotype LIMIT 10;
+----+-------------+-----------+----------+------------+----------+-----------+
| id | pipeline_id | sample_id | alias_id | clustering | genotype | haplotype |
+----+-------------+-----------+----------+------------+----------+-----------+
|  1 |           1 |      1481 |   139660 | PHR        | BB       | NULL      |
|  2 |           1 |      1863 |   139660 | PHR        | BB       | NULL      |
|  3 |           1 |      1483 |   139660 | PHR        | AA       | NULL      |
|  4 |           1 |      1482 |   139660 | PHR        | AB       | NULL      |
|  5 |           1 |      1484 |   139660 | PHR        | AB       | NULL      |
|  6 |           1 |      1486 |   139660 | PHR        | BB       | NULL      |
|  7 |           1 |      1487 |   139660 | PHR        | AB       | NULL      |
|  8 |           1 |      1488 |   139660 | PHR        | BB       | NULL      |
|  9 |           1 |      1489 |   139660 | PHR        | AB       | NULL      |
| 10 |           1 |      1490 |   139660 | PHR        | AB       | NULL      |
+----+-------------+-----------+----------+------------+----------+-----------+
10 rows in set (0.00 sec)

mysql> SELECT * FROM marker LIMIT 10;
+----+-------------+---------------+---------+--------+---------------------------------------------------------------+
| id | probe_id    | snp_id        | alleles | strand | context                                                       |
+----+-------------+---------------+---------+--------+---------------------------------------------------------------+
|  1 | AX-89803679 | Affx-88819427 | /GGA    | f      | ATATCAATAGAGGCCATGAGTAAAAACCAG/GGAGTAGTGACTCTGAGGGGATGAAAACTT |
|  2 | AX-89804064 | Affx-88831685 | /GAG    | f      | ACCACTGGAACATAAGTTGGGAATGGATGA/GGGAATTCATACAAACTATGAAAGGAGCTT |
|  3 | AX-89804316 | Affx-88832267 | /AGG    | f      | CAAGCTATATCATTTCCTTCGACTTCAACA/AGGAGTTTTGCTGGACTCCCCATCCTACCT |
|  4 | AX-89805693 | Affx-88810467 | T/C     | f      | TACCAGAGTTGCTGCTTAAAGTATTAGAAC/TTATCGAAAAGAGGGTAGGTCTTGTCTCTA |
|  5 | AX-89806602 | Affx-88819381 | /TCT    | f      | TTCCGGCACACACGCAATGCATTATGCATG/TGTAAATGTCACACTTGTAAAGATTGAGCG |
|  6 | AX-89779627 | Affx-88809314 | A/C     | f      | TTTCACGTACTTCCTCGACTTCGGCTTAAT/TCCACCGCCATTGAAGCAATCTCACTACAC |
|  7 | AX-89782268 | Affx-88819410 | T/C     | f      | CTTCTTCAATAACAAGTTGGAACAGAAACC/GAGTTTTCTATTGGTGATTGTTCGTGATTT |
|  8 | AX-89782909 | Affx-88819426 | T/C     | f      | TACTCTATGTGATGGAAGAGCAGCACAAGA/CATCACCCACATGGCCACCTCCTTGGCCCA |
|  9 | AX-89783470 | Affx-88819558 | T/G     | f      | TGCGTTCTAAAGTTTTTGCCAAGGTTTCAA/ATCCATGGCTGAATGAGTTTCTCTTGTATG |
| 10 | AX-89783911 | Affx-88819697 | T/C     | f      | ATCAAAACCATAAGGAACACAGAACAGAAC/TTTCCCAATAGATGGGCCACTTCTCCCTTC |
+----+-------------+---------------+---------+--------+---------------------------------------------------------------+
10 rows in set (0.00 sec)

mysql> SELECT * FROM pipeline_run LIMIT 10;
+----+--------------------------+--------------------------------------------------------------------------------+---------------------------------------------------------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
| id | name                     | script_path                                                                    | data_path                                                                       | date       | notes                                                                                                                              |
+----+--------------------------+--------------------------------------------------------------------------------+---------------------------------------------------------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
|  1 | istraw35 first plate     | /home/vicker/git_repos/axiom_strawberry/istraw35_call/000_istraw35_call.sh     | /home/vicker/octoploid_mapping/istraw35_call/affy_calls/markers/mhr_phr_nmh.tsv | 2017-05-11 | command used: affycall_apt1.19.0.sh input_files istraw35 0.82 96 0.01 affy_calls                                                   |
|  2 | consensus map 4 pipeline | /home/vicker/git_repos/axiom_strawberry/consensus_call4/000_affycall_and_qc.sh | /home/vicker/octoploid_mapping/consensus_map4/popn_*/markers/mhr_phr_nmh.tsv    | 2016-11-17 | just mapping population samples, grouped by population, loading raw genotype calls without genetic mapping based error corrections |
+----+--------------------------+--------------------------------------------------------------------------------+---------------------------------------------------------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
2 rows in set (0.00 sec)

mysql> SELECT * FROM sample LIMIT 10;
+----+----------+--------------------+-----------------------------------------------+----------+------------+-------+
| id | clone_id | file               | path                                          | type     | date       | batch |
+----+----------+--------------------+-----------------------------------------------+----------+------------+-------+
|  1 |     2083 | inra_1_X00_009.CEL | /home/vicker/octoploid_mapping/caxcf/celfiles | istraw90 | 2014-12-10 | inra  |
|  2 |     2048 | inra_1_X00_010.CEL | /home/vicker/octoploid_mapping/caxcf/celfiles | istraw90 | 2014-12-10 | inra  |
|  3 |     2029 | inra_1_X00_011.CEL | /home/vicker/octoploid_mapping/caxcf/celfiles | istraw90 | 2014-12-10 | inra  |
|  4 |     2066 | inra_1_X00_013.CEL | /home/vicker/octoploid_mapping/caxcf/celfiles | istraw90 | 2014-12-10 | inra  |
|  5 |     2088 | inra_1_X00_014.CEL | /home/vicker/octoploid_mapping/caxcf/celfiles | istraw90 | 2014-12-10 | inra  |
|  6 |     2168 | inra_1_X00_015.CEL | /home/vicker/octoploid_mapping/caxcf/celfiles | istraw90 | 2014-12-10 | inra  |
|  7 |     2086 | inra_1_X00_018.CEL | /home/vicker/octoploid_mapping/caxcf/celfiles | istraw90 | 2014-12-10 | inra  |
|  8 |     2152 | inra_1_X00_019.CEL | /home/vicker/octoploid_mapping/caxcf/celfiles | istraw90 | 2014-12-10 | inra  |
|  9 |     2053 | inra_1_X00_020.CEL | /home/vicker/octoploid_mapping/caxcf/celfiles | istraw90 | 2014-12-10 | inra  |
| 10 |     2102 | inra_1_X00_022.CEL | /home/vicker/octoploid_mapping/caxcf/celfiles | istraw90 | 2014-12-10 | inra  |
+----+----------+--------------------+-----------------------------------------------+----------+------------+-------+

mysql> SELECT * FROM sample_tag LIMIT 10;
Empty set (0.00 sec)

SELECT * FROM clone INTO OUTFILE 'clone.tsv' FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';
ERROR 1045 (28000): Access denied for user 'marias'@'%' (using password: YES)

input=/home/sobczm/popgen/snp/snp_chip
cd $input

#Temporary workaround:
echo "SELECT * FROM clone" | mysql -u marias -h mongo -D strawberry_samples -p$(cat /home/sobczm/bin/mysql_sample_database/login)> clone.tsv

#List all the samples and their cultivars (clones) output using pipeline 1
b="SELECT DISTINCT s.id, s.clone_id, c.name, g.pipeline_id FROM sample s JOIN clone c ON s.clone_id = c.id JOIN genotype g ON s.id=g.sample_id WHERE g.pipeline_id = 1 ORDER BY c.name;"

echo $b | mysql -u marias -h mongo -D strawberry_samples -p$(cat /home/sobczm/bin/mysql_sample_database/login)> pipe1.tsv

#List all the samples and their cultivars (clones) output using pipeline 2
c="SELECT DISTINCT s.id, s.clone_id, c.name, g.pipeline_id
FROM sample s JOIN clone c ON s.clone_id = c.id JOIN genotype g ON s.id=g.sample_id WHERE g.pipeline_id = 2 ORDER BY c.name;"

echo $c | mysql -u marias -h mongo -D strawberry_samples -p$(cat /home/sobczm/bin/mysql_sample_database/login)> pipe2.tsv

#Extract source origin of clones selected for downstream analysis.
d="SELECT id, clone_id, file, path, type, date, batch FROM sample WHERE clone_id in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,3332,3333,3334,3335,3336,3337,3338,3339,3340,3341,3342,3344,3345,3346,3347,3348,3349,3350,3351,3352,3353,3354,3355,3356,3357,3358,3359,3360,3361,3362,3363,3394,3395,3396,3397,3398,3400,3401,3402,3403,3404,3405,3406,3407,3408,3409,3410,3411,3412,3413,3414,3415,3416,3417,3418,3419,3423,3590,3591,3592,3593,3596,3600,3606,3611,3616,3619,3622,3625,3628,3641,3644,3647,3654,3655,3656,3657,3658,3659,3660,3661,3669,3670,3680,3681,3690,3695,3701,3708,3735,3744,3745,3749,3755,4134,4136,4158,4162,4186,4477,4479,4481,3721,3607,3612,3751,3731,3750,3739,3736,3646,3734,3722);"

echo $d | mysql -u marias -h mongo -D strawberry_samples -p$(cat /home/sobczm/bin/mysql_sample_database/login)> sample_origin.tsv

#Check the origin of samples with unknown cultivar
e="SELECT clone_id, file, path, type, date, batch FROM sample WHERE clone_id in (3594,3595,3597,3598,3599,3601,3602,3603,3604,3605,3607,3608,3609,3610,3612,3613,3614,3615,3617,3618,3620,3621,3623,3624,3626,3627,3629,3630,3631,3633,3634,3635,3636,3637,3638,3639,3640,3642,3643,3645,3646,3648,3649,3650,3651,3652,3653,3662,3663,3664,3665,3666,3667,3668,3671,3672,3673,3674,3675,3676,3677,3678,3679,3682,3683,3684,3685,3686,3687,3688,3689,3691,3692,3693,3694,3696,3697,3698,3699,3700,3702,3703,3704,3705,3706,3707,3709,3710,3711,3712,3713,3714,3715,3716,3717,3718,3719,3720,3722,3723,3724,3725,3726,3727,3728,3729,3730,3731,3732,3733,3734,3736,3737,3738,3739,3740,3741,3742,3743,3746,3747,3748,3750,3751,3752,3753,3754);"

echo $e | mysql -u marias -h mongo -D strawberry_samples -p$(cat /home/sobczm/bin/mysql_sample_database/login)> sample_origin2.tsv

#Extract sample IDs of the cultivars to be analysed, excluding the rogue samples. 
f="SELECT id FROM sample WHERE clone_id in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,3332,3333,3334,3335,3336,3337,3338,3339,3340,3341,3342,3344,3345,3346,3347,3348,3349,3350,3351,3352,3353,3354,3355,3356,3357,3358,3359,3360,3361,3362,3363,3394,3395,3396,3397,3398,3400,3401,3402,3403,3404,3405,3406,3407,3408,3409,3410,3411,3412,3413,3414,3415,3416,3417,3418,3419,3423,3590,3591,3592,3593,3596,3600,3606,3611,3616,3619,3622,3625,3628,3641,3644,3647,3654,3655,3656,3657,3658,3659,3660,3661,3669,3670,3680,3681,3690,3695,3701,3708,3735,3744,3745,3749,3755,4134,4136,4158,4162,4186,4477,4479,4481,3721,3607,3612,3751,3731,3750,3739,3736,3646,3734,3722) AND clone_id NOT IN (SELECT clone_id AS ci FROM clone_tag WHERE tag = "rogue");"

echo $f | mysql -u marias -h mongo -D strawberry_copy -p$(cat /home/sobczm/bin/mysql_sample_database/login)> samples_to_analyze.txt

scripts=/home/sobczm/bin/popgen/snp

#Extract genotypes for selected samples for downstream processing.
python $scripts/ananassa_genotypes_db.py samples_to_analyze.txt samples_to_analyze.out

#Output the genotypes in the VCF format with locations substituted 
according to map positions relative to vesca 1.1. 
python $scripts/ananassa_genotypes_vcf.py samples_to_analyze.out istraw90_vesca_v1.1_snp_positions.gff3

#General VCF stats (remember that vcftools needs to have the PERL library exported)
python $scripts/substitute_sample_names.py samples_to_analyze.out.vcf cultivar_names.txt sample_clone_id.txt

perl /home/sobczm/bin/vcftools/bin/vcf-stats \
samples_to_analyze.out_new_names.vcf  >samples_to_analyze.out_new_names.stat

#Sort the VCF file.
cat samples_to_analyze.out_new_names.vcf | perl /home/sobczm/bin/vcftools/bin/vcf-sort > samples_to_analyze.out_new_names_sorted.vcf

#Filter the VCF file to retain only markers with 80% genotypes.
vcftools=/home/sobczm/bin/vcftools/bin
filename=samples_to_analyze.out_new_names_sorted.vcf 
$vcftools/vcftools --vcf $filename --max-missing 0.8 --recode --out ${filename%.vcf}_filtered

#Remove any SNPs with missing data
vcftools=/home/sobczm/bin/vcftools/bin
filename=samples_to_analyze.out_new_names_sorted.vcf 
$vcftools/vcftools --vcf $filename --max-missing 1 --recode --out ${filename%.vcf}_nomissing

#Carry out PCA and plot the results
#First just get only sample num IDs.
sed 's/_\w\+//g' samples_to_analyze.out_new_names_sorted_nomissing.recode.vcf >samples_to_analyze.out_new_names_sorted_nomissing.recode.num.vcf
Rscript --vanilla $scripts/pca.R samples_to_analyze.out_new_names_sorted_nomissing.recode.num.vcf

#Make an NJ tree 
$scripts/nj_tree.sh samples_to_analyze.out_new_names_sorted_nomissing.recode.vcf 2

#Calculate the index for percentage of shared SNP alleles between the individs.
$scripts/similarity_percentage.py samples_to_analyze.out_new_names_sorted_nomissing.recode.vcf
#Visualise the output as heatmap and clustering dendrogram
Rscript --vanilla $scripts/distance_matrix.R samples_to_analyze.out_new_names_sorted_nomissing.recode_distance.log

#Create vesca1.1 genome db with Snpeff and annotate samples. Have to do it chrom by chrom, otherwise does not work.
strawberry=/home/sobczm/popgen/renseq/strawberry/genome
/home/sobczm/bin/popgen/summary_stats/build_genome_database.sh $strawberry/fvesca_v1.1_all.fa $strawberry/Fragaria_vesca_v1.1.a2.gff3 vesca1.1
#Annotate the output file (no unanchored variants)
snpeff=/home/sobczm/bin/snpEff
cat samples_to_analyze.out_new_names_sorted_filtered.recode.vcf >samples_to_analyze.out_new_names_sorted_filtered.recode.bak.vcf
for k in {1..7}
do
vcf=samples_to_analyze.out_new_names_sorted_filtered.recode.bak.vcf
java -Xmx4g -jar $snpeff/snpEff.jar -v -ud 0 vesca1.1_${k} $vcf >> ${vcf%.vcf}_annotated.vcf
done

#Create subsamples of SNPs containing those in a given category
vcf=samples_to_analyze.out_new_names_sorted_filtered.recode.bak_annotated.vcf
#non-synonymous
java -jar $snpeff/SnpSift.jar filter "(ANN[0].EFFECT has 'missense_variant') || (ANN[0].EFFECT has 'nonsense_variant')" $vcf > ${vcf%.vcf}_nonsyn.vcf
#synonymous
java -jar $snpeff/SnpSift.jar filter "(ANN[0].EFFECT has 'synonymous_variant')"  $vcf > ${vcf%.vcf}_syn.vcf
#Four-fold degenrate sites (output file suffix: 4fd)
python /home/sobczm/bin/popgen/summary_stats/parse_snpeff_synonymous.py ${vcf%.vcf}_syn.vcf


#Calculate nucleotide diversity for different subsets.
vcftools=/home/sobczm/bin/vcftools/bin
$vcftools/vcftools --vcf samples_to_analyze.out_new_names_sorted_filtered.recode.bak.vcf --site-pi  --out nucleotide_diversity.all 
$vcftools/vcftools --vcf ${vcf%.vcf}_nonsyn.vcf --site-pi  --out nucleotide_diversity.nonsyn
$vcftools/vcftools --vcf ${vcf%.vcf}_syn.vcf --site-pi  --out nucleotide_diversity.syn
$vcftools/vcftools --vcf ${vcf%.vcf}_syn_4fd.vcf --site-pi  --out nucleotide_diversity.syn4fd

#Calculate Mean, SD, Max, MIn of the nucleotide diversity 
R
my_data <- read.csv("nucleotide_diversity.all.sites.pi", sep="\t", header=TRUE)
summary(my_data$PI)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA
 0.0000  0.1091  0.1920  0.2211  0.3285  0.5041       6 


my_data <- read.csv("nucleotide_diversity.nonsyn.sites.pi", sep="\t", header=TRUE)
summary(my_data$PI)

   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA 
 0.0000  0.0943  0.1654  0.2040  0.2981  0.5041       6 


my_data <- read.csv("nucleotide_diversity.syn.sites.pi", sep="\t", header=TRUE)
summary(my_data$PI)

   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA
 0.0000  0.0943  0.1788  0.2140  0.3187  0.5041       6 


my_data <- read.csv("nucleotide_diversity.syn4fd.sites.pi", sep="\t", header=TRUE)
summary(my_data$PI)

   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA
   0.0000  0.1091  0.1788  0.2105  0.2981  0.5041       6 


###Repeat the analysis using newer genotypes in the strawberry_samples db in a new subfolder more_samples.
#All-sites nuc div:
  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.0000  0.1169  0.1992  0.2306  0.3378  0.5016 
#nonsyn
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA
 0.0000  0.1059  0.1845  0.2171  0.3157  0.5015       6 
#syn
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA 
 0.0000  0.1169  0.1895  0.2204  0.3157  0.5016       6
 #4fd
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA
 0.0000  0.1169  0.1895  0.2168  0.3042  0.5016       6 

