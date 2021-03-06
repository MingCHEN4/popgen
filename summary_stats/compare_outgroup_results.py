#! /usr/bin/env python
from sys import argv
import os, sys, re, argparse
from collections import defaultdict as dd

#The script to parse AA fields from two independent annotations of a given genome using
#a) read mapping to the common reference genome (script annotate_vcf_aa.py)
#b) whole genome alignment of contigs from the focal species and sister species with mauve-parser (script annotate_gen_aa.py).

#Input:
#1st argument: first VCF file with AA field annotations (read mapping to common reference)
#2nd argument: second VCF file with AA field annotations  (whole genome alignment of contigs)
#3rd argument: the ploidy of the organism (arguments accepted: 1 or 2)
#4th argument: add the fake genotype entry (options: Y or N)

#Output:
##VCF file with high confidence consensus AA field annotation ONLY (ie. present in both input sources).
# Suffix: "_cons"
##VCF file with consensus AA field annotation AND present only in single sources.
# Suffix: "_cons_all"

#The script will produce a final AA field annotation using the following heuristics:
#1) If AA fields congruent -> print the AA field.
#2) If two different AA identified -> remove the AA field
#3) If one AA identified using one method and two AA using the other method, including
#the allele in method one, then -> print tha AA field with two alleles.
#4) If AA field identified using only one method -> print the AA field (only to file cons_all)

script, vcf1, vcf2, ploidy, fake = argv

bare = r"(\w+)(.vcf)"
out_sub = r"\1_cons_all.vcf"
out_sub2 = r"\1_cons.vcf"
out = re.sub(bare, out_sub, vcf1)
out2 = re.sub(bare, out_sub2, vcf1)
out_h = open(out, 'w')
out_h2 = open(out2, 'w')

mapping_results = dd(lambda: dd(list))
aa_match = r"(AA=)(.*)"

counter_vcf = 0
counter_aa = 0
counter_dif = 0
counter_vcf1 = 0
counter_vcf2 = 0

def empty_fake_genotype(fh):
    if fake == "Y":
        fh.write("." + "\t" + ".")

def write_no_aa(fields, fh):
    for z in fields[:7]:
        fh.write(z + "\t")
    fh.write("." + "\t")
    for z in fields[8:]:
        fh.write(z + "\t")
    empty_fake_genotype(fh)
    fh.write("\n")

def add_genotype(ploidy, current_allele, alleles, fh):
    if ploidy == "1":
        if len(current_allele) == 1:
            fh.write(alleles[current_allele[0]] + ":20" + "\t" + alleles[current_allele[0]] + ":20")
        elif len(current_allele) == 2:
            fh.write(alleles[current_allele[0]] + ":20" + "\t" + alleles[current_allele[1]] + ":20")
    elif ploidy == "2":
        if len(current_allele) == 1:
            fh.write(alleles[current_allele[0]] + "/" + alleles[current_allele[0]] + ":20")
            fh.write("\t" + alleles[current_allele[0]] + "/" + alleles[current_allele[0]] + ":20")
        elif len(current_allele) == 2:
            fh.write(alleles[current_allele[0]] + "/" + alleles[current_allele[1]] + ":20")
            fh.write("\t" + alleles[current_allele[0]] + "/" + alleles[current_allele[1]] + ":20")

def write_output(fields, current_allele, alleles, fh):
    for z in fields[:7]:
        fh.write(z + "\t")
    fh.write("AA=" + ','.join(current_allele) + "\t")
    for z in fields[8:]:
        fh.write(z + "\t")
    if fake == "Y":
        add_genotype(ploidy, current_allele, alleles, fh)
    fh.write("\n")

vcf_h = open(vcf1)
#Read in AA in the first VCF file into memory
for line in vcf_h:
    if line.startswith("#"):
        pass
    else:
        fields = line.split()
        if re.match("AA=", fields[7]):
            al = re.search(aa_match, fields[7])
            alleles = sorted(al.group(2).split(","))
            mapping_results[fields[0]][fields[1]] = alleles
vcf_h.close()

vcf_h2 = open(vcf2)
#Read in AA in the second VCF file and print results
for line in vcf_h2:
    if line.startswith("##"):
        out_h.write(line)
        out_h2.write(line)
    elif line.startswith("#"):
        out_h.write(line.strip())
        out_h2.write(line.strip())
        if fake == "Y":
            out_h.write("\t" + "ancestral_1" + "\t" + "ancestral_2" + "\n")
            out_h2.write("\t" + "ancestral_1" + "\t" + "ancestral_2" + "\n")
    else:
        alleles_present = dict()
        counter_vcf += 1
        fields = line.split()
        #Collect the alleles present:
        alleles_present[fields[3]] = "0"
        alleles_present[fields[4]] = "1"
        #Check if AA field present
        if re.match("AA=", fields[7]):
            al = re.search(aa_match, fields[7])
            #AA alleles in the current VCF file
            alleles2 = sorted(al.group(2).split(","))
            #AA alleles in the previous VCF file
            alleles = mapping_results[fields[0]][fields[1]]
            #Check if AA defined in the previous VCF file
            if len(alleles) > 0:
                common = list(set(alleles).intersection(alleles2))
                #Check if more than 1 allele present in the difference between the 2 sources
                diff = set(alleles).symmetric_difference(alleles2)
                #check if any common ancestral alleles shared. If yes, proceed.
                if len(common) > 0:
                    #Check if criterion 3 for retaining AA met:
                    if len(diff) > 1:
                        #remove the AA field
                        counter_dif += 1
                        write_no_aa(fields, out_h)
                        write_no_aa(fields, out_h2)
                    else:
                        #Union of two lists:
                        aa_allele = list(set(alleles + alleles2))
                        counter_aa += 1
                        write_output(fields, aa_allele, alleles_present, out_h)
                        write_output(fields, aa_allele, alleles_present, out_h2)
                else:
                    #remove the AA field
                    counter_dif += 1
                    write_no_aa(fields, out_h)
                    write_no_aa(fields, out_h2)
            else:
                #Add the AA field only from VCF2
                counter_vcf2 += 1
                out_h.write(line.strip())
                if fake == "Y":
                    add_genotype(ploidy, alleles2, alleles_present)
                out_h.write("\n")
                write_no_aa(fields, out_h2)
        else:
            alleles = mapping_results[fields[0]][fields[1]]
            #Check if AA field present in VCF1 and if so add it.
            if len(alleles) > 0:
                counter_vcf1 += 1
                write_output(fields, alleles, alleles_present, out_h)
                write_no_aa(fields, out_h2)
            else:
                out_h.write(line.strip())
                out_h2.write(line.strip())
                empty_fake_genotype(out_h)
                empty_fake_genotype(out_h2)
                out_h.write("\n")
                out_h2.write("\n")

vcf_h2.close()
out_h.close()
out_h2.close()

print("In total, {0} variants were annotated with consensus ancestral allele, ".format(counter_aa) +
"out of {0} variants in the file. {1} annotations were found to differ between the ".format(counter_vcf, counter_dif) +
"two input annotation sources, and were rejected, while {0} and {1} ancestral allele ".format(counter_vcf1, counter_vcf2) +
"annotations were present only in the input annotation source 1 or 2, respectively, and were included.")
