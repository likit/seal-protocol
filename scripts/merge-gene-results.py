#!/usr/bin/env python
'''Description'''
import sys
import pandas as pd
from glob import glob


def merge(path):
    n = 0
    for fi in glob('*.genes.results'):
        n += 1
        try:
            temp = pd.read_csv(fi, header=0, sep='\t')
            d['TPM'] += temp['TPM']
            d['FPKM'] += temp['FPKM']
            print >> sys.stderr, fi
        except NameError:
            print >> sys.stderr, fi, ' #1'
            d = pd.read_csv(fi, header=0, sep='\t')

    d['TPM'] /= n
    d['FPKM'] /= n
    d.to_csv(sys.stdout, sep='\t',
                header=True, index=False)


def main():
    '''Main function'''

    path = sys.argv[1]  # input directory
    merge(path)


if __name__=='__main__':
    main()
