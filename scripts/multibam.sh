#!/bin/sh -login
#PBS -l nodes=1:ppn=1,mem=8gb,walltime=4:00:00
#PBS -M preeyano@msu.edu
#PBS -m abe
#PBS -A ged-intel11
#PBS -N multibamcov

module load BEDTools/2.17.0
cd ${PBS_O_WORKDIR}
