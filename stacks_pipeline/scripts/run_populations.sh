#!/bin/bash
set -e
set -u
set -o pipefail

work=/home/trevor/dev/lc_refuges_manuscript
popmap_dir=$work/stacks_pipeline

popmaps=($(find $popmap_dir -type f -name "popmap*.tsv"))

for file in "${popmaps[@]}"; do
    outname=$(basename $file '.tsv')
    mkdir $work/data/$outname
    populations --in-path $popmap_dir/denovo.all.pops --popmap $file --out-path $work/data/$outname --min-samples-per-pop 0.80 --min-populations 2 --min-mac 3 -t 16 --batch-size 100000 --hwe --fstats --phylip --phylip-var --vcf --plink --genepop --write-single-snp
done

