#!/bin/bash
set -e
set -u
set -o pipefail

# Absolute path to the stacks 2 protocol directory
work=/home/trevor/dev/lc_refuges_manuscript

# Loop over the M values
# Iterates over every value between 1 and 12
for M in {1..12}; do
    # This creates a new output directory per Stacks run
    echo "Running pipeline for M, n = $M"
    out=$work/stacks_pipeline/param_opt/denovo.M${M}
    mkdir -p $out
    # Move into the new directory
    cd $out
    # Stacks command
    denovo_map.pl --samples $work/data/raw --popmap $work/stacks_pipeline/opt_popmap.tsv --out-path $out --paired -M $M -n $M -T 16 --min-samples-per-pop 0.8 --rm-pcr-duplicates                            # Remove PCR duplicates
done