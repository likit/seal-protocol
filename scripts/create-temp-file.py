#!/usr/bin/env python
'''Runs CDHIT on each transcript family.'''

import sys
import subprocess as sp
from Bio import SeqIO
from collections import defaultdict


def split_family(infile):
    '''Writes sequences in a family into a new file.'''

    family = defaultdict(list)
    for seq in SeqIO.parse(infile, 'fasta'):
        fam = seq.id.split('.')[-1]
        family[fam].append(seq)

    for fam in family:
        SeqIO.write(family[fam], '%s.tmp' % fam, 'fasta')

def main():
    '''Main function'''

    infile = sys.argv[1]  # input FASTA file
    split_family(infile)


if __name__=='__main__':
    main()

