#!/bin/bash

# split families into two files for big and small families.
python ~/seal-protocol/scripts/split-big-family.py trinity-mirounga.renamed.fa

# create a temporary file for each family for CDHIT
python ~/seal-protocol/scripts/create-temp-file.py trinity-mirounga.renamed.fa.big

# run CDHIT on each family
for f in tr*.tmp; do cd-hit-est -T 0 -d 0 -c 0.95 -M 0 -i $f -o $f.nr; done

# merge results
cat tr*tmp.nr > trinity-mirounga.renamed.fa.big.nr
cat trinity-mirounga.renamed.fa.big.nr trinity-mirounga.renamed.fa.small > trinity-mirounga.renamed.fa.cdhit

# delete temp files
rm tr*tmp*
