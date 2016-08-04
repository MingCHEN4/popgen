
Copy gene models of sequenced *Fusarium oxysporum fsp. cepae* and outgroup *F. proliferatum*
```
s_dir=/home/groups/harrisonlab/project_files/fusarium/gene_pred/codingquary
o_dir=/home/sobczm/popgen/input
cd $s_dir
cd F.oxysporum_fsp_cepae
cp -r 125  55  A1-2  A13  A23  A28  CB3  D2  Fus2 HB6  PG $o_dir 
cd $s_dir
cd F.proliferatum
cp -r A8 $o_dir
```
Copy gene models from *F. oxysporum* reference sequences 
```
s_dir=/home/groups/harrisonlab/project_files/fusarium/assembly/external_group
## Fusarium oxysporum fo47
cd $s_dir
cp -r F.oxysporum/fo47 $o_dir
## F.oxysporum fsp lycopersici (FoL)
cd $s_dir
cd F.oxysporum_fsp_lycopersici
cp -r 4287/Fusox1 $o_dir
```
Download remaining *F.oxysporum* genomes
```

```
