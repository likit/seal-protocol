#!/bin/sh -login
#PBS -l nodes=1:ppn=1,mem=8gb,walltime=1:00:00
#PBS -M preeyano@msu.edu
#PBS -m abe
#PBS -A ged-intel11
#PBS -N pathway_job

module load BEDTools
module load bowtie
module load BLAST
export PATH=$PATH:~/rsem-1.2.7

cd ${PBS_O_WORKDIR}

sh ~/seal-protocol/scripts/pathway.sh ${input}
