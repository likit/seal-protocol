#!/usr/bin/env python
'''Description'''
import sys
import csv

def split(infile):
    op1 = '%s.%s' % ('ortholog', infile)
    op2 = '%s.%s' % ('homolog', infile)
    writer1 = csv.writer(open(op1, 'w'), dialect='excel-tab')
    writer2 = csv.writer(open(op2, 'w'), dialect='excel-tab')
    csvfile = open(infile)
    reader = csv.reader(csvfile, delimiter=',')
    reader.next()
    for n, line in enumerate(reader):
        if n % 1000 == 0:
            print '...', n

        orthol = line[3]
        homol = line[5]
        trid = line[0]

        if orthol != '':
            orthol = line[3].split('|')[-2].split('.')[0]
            writer1.writerow([trid, line[3], orthol])
        if homol != '':
            homol = line[5].split('|')[-2].split('.')[0]
            writer2.writerow([trid, line[5], homol])


def main():
    '''Main function'''

    input_file = sys.argv[1]
    split(input_file)


if __name__=='__main__':
    main()

