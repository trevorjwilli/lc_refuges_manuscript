#!/bin/bash
set -e
set -u
set -o pipefail

# Absolute path to the stacks 2 protocol directory
work=/home/trevor/dev/lc_refuges_manuscript
out=$work/stacks_pipeline/denovo.all.pops

mkdir -p $out
cd $out

denovo_map.pl --samples $work/data/raw --popmap $work/stacks_pipeline/popmap.tsv --out-path $out --paired -M 2 -n 2 --min-populations 2 --min-samples-per-pop 0.8 --rm-pcr-duplicates --gt-alpha 0.01 -T 16 
