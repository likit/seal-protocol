#!/usr/bin/env python
'''Splits FASTA sequences from Eel pond protocol into two files.

One file will contain a family with the number of transcripts fewer
than the cutoff. The other will contain a family with the number
of transcripts greater than the cutoff.

'''
import sys
from Bio import SeqIO
from collections import defaultdict


def split(infile, cutoff=20):
    '''Split sequences in infile into two files.

    Arguments:
        infile = input FASTA file
        cutoff = the number of transcripts in a family
    '''

    seqdict = {}
    famdict = defaultdict(int)

    # gather family information
    print >> sys.stderr, 'gathering information...'
    for line in open(infile):
        if line.startswith('>'):
            seqid = line.split()[0].lstrip('>')
            fam = seqid.split('.')[-1]  # family ID
            seqdict[seqid] = fam
            famdict[fam] += 1
    print >> sys.stderr, 'total families = %d' % len(famdict)

    # open an output file for big families
    bigfile = open('%s.big' % infile, 'w')
    # open an output file for small families
    smallfile = open('%s.small' % infile, 'w')

    for seq in SeqIO.parse(infile, 'fasta'):
        fam = seqdict[seq.id]
        if famdict[fam] > cutoff:
            SeqIO.write(seq, bigfile, 'fasta')
        else:
            SeqIO.write(seq, smallfile, 'fasta')

    bigfile.close()
    smallfile.close()


def main():
    '''Main function'''

    infile = sys.argv[1]
    if len(sys.argv) < 3:  # if no cutoff specified
        print >> sys.stderr, \
            'No cutoff specified, use the default cutoff of 20.'
        split(infile)
    else:
        cutoff = int(sys.argv[2])  # if cutoff specified
        split(infile, cutoff)


if __name__=='__main__':
    main()

