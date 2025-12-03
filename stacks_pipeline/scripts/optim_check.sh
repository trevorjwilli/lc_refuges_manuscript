#!/bin/bash
set -e
set -u
set -o pipefail

optim_path=/home/trevor/dev/lc_refuges_manuscript/stacks_pipeline/param_opt
out_path=/home/trevor/dev/lc_refuges_manuscript/stacks_pipeline/param_opt_results.txt

for dir in $optim_path/*/; do
    if [ -d "$dir" ]; then
      param=$(basename "$dir") 
      nloci=$(cat $dir/populations.sumstats.tsv | grep -v '^#' | cut -f 1 | sort -n -u | wc -l)
      echo "$param $nloci" >> $out_path
   fi
done
