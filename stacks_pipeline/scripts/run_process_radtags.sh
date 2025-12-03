#!/bin/bash
set -e
set -u
set -o pipefail

if [ $# -lt 3 ]; then
    echo "ERROR: Need to suppply directory with data as an argument"
fi

process_radtags -1 $1/plate1/plate1_R1.fastq.gz -2 $1/plate1/plate1_R2.fastq.gz -o $3 -b $2/barcodes_1_nosite.txt -e sbfI -r -c -q --threads 16 &> process_radtags.plate1.oe
mv $3/process_radtags.log $3/process_radtags_plate1.log
process_radtags -1 $1/plate2/plate2_R1.fastq.gz -2 $1/plate2/plate2_R2.fastq.gz -o $3 -b $2/barcodes_2_nosite.txt -e sbfI -r -c -q --threads 16 &> process_radtags.plate2.oe
mv $3/process_radtags.log $3/process_radtags_plate2.log
process_radtags -1 $1/plate3/plate3_R1.fastq.gz -2 $1/plate3/plate3_R2.fastq.gz -o $3 -b $2/barcodes_3_nosite.txt -e sbfI -r -c -q --threads 16 &> process_radtags.plate3.oe
mv $3/process_radtags.log $3/process_radtags_plate3.log
