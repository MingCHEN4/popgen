##Index to "popgen" analyses available to use
###**Please make sure that the program you are trying to use has its dependencies in the PATH. See:**
###https://github.com/harrisonlab/popgen/blob/master/programs.md
My current bash profile
`/home/sobczm/bin/maria_bash_profile`

*What directories are there?*

1. Phylogenetics
2. Snp
3. Summary stats
4. Clock
5. Codon

###*Each directory contains a README.md file listing shell scripts which contain a model (example) analysis using scripts in a given directory.
###*Read the header of each individual script you are trying to exectute to find out about the options, input and output file.

*What is in each directory? Only listing re-usable analyses*

1. Making Bayesian phylogenetic trees from gene sequences
2. Mapping reads to reference, cleaning the mapped files and calling SNPs. Filtering SNPs and their basic summary stats. Various methods of establishing population structure, including SNP-based NJ trees.
3. More complex analyses involving SNP sampling across populations identified in 2. Divergence, natural selection, recombination.
4. De novo motif discovery and motif scanning. Orthology analysis and automated generation of ortholog trees. Pairwise, branch-site and branch dN/dS codeml models.
5. Analysis of gene codon usage and gene duplication levels.

##Phylogenetics
###Scripts to make a Bayesian phylogenetic tree.
1. Model analysis file: [BUSCO_analysis.sh] (https://github.com/harrisonlab/popgen/blob/master/phylogenetics/BUSCO_analysis.sh)
[sub_BUSCO_fungi.sh] (https://github.com/harrisonlab/popgen/blob/master/phylogenetics/sub_BUSCO.sh) 
Establish the number of single copy Fungal/Eukaryotic/Plant/Prokaryotic/ conserved genes in a genome or transcriptome. 
[get_alignments.pl] (https://github.com/harrisonlab/popgen/blob/master/phylogenetics/get_alignments.pl) 
This is the script to use if you want to follow the steps in the model analysis file and create individual alignments for each BUSCO gene found to be complete in each genome analysed. These gene alignments (only CDS recommended) can then be used to make trees in the next step.
2. Model analysis file: [pre_BEAST_prep.sh] (https://github.com/harrisonlab/popgen/blob/master/phylogenetics/pre_BEAST_prep.sh)
[sub_mafft_alignment.sh] (https://github.com/harrisonlab/popgen/blob/master/phylogenetics/sub_mafft_alignment.sh) 
Quickly align the sequences generated in 1. to be used for tree construction. The script loops over all the FASTA files in the directory and tries to align sequences inside each one.
[calculate_nucleotide_diversity.py] (https://github.com/harrisonlab/popgen/blob/master/phylogenetics/calculate_nucleotide_diversity.py)
calculates basic sequence diversity stats for each alignment which could then guide selection of individual genes towards making the
phylogenetic tree (see the model analysis file for a example of an analysis)
*The remainder of the model analysis file describes establishing the correct model of evolution for each gene using PartitionFinder that can be then implemented within BEAST. With some prior information on that, this step can be potentially abandoned.*

3. Model analysis file: [BEAST_run.sh] (https://github.com/harrisonlab/popgen/blob/master/phylogenetics/BEAST_run.sh)
The BEAST analysis has to be so far set-up by hand. A guide to do so and obtain a final tree is given in the model analysis file above.
