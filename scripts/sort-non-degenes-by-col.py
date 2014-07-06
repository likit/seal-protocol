#!/usr/bin/env python
'''Description'''
import sys
import pandas as pd
import glob

def load_data(pathdir, colname):
    alldata = pd.DataFrame()
    for f in glob.glob("*genes.results"):
        print >> sys.stderr, 'loading data from %s...' % f
        d = pd.read_csv(f, header=0, sep='\t', index_col=0)
        if alldata.empty:
            alldata = pd.DataFrame(d[colname])
            alldata.columns = [f]
            alldata['total'] = d[colname]
        else:
            alldata[f] = d[colname]
            alldata['total'] += d[colname]
    return alldata

def select(alldata, nondegenes):
    nd = set()  # non-degenes
    keep = []
    for line in open(nondegenes):
        nd.add(line.strip())

    # select non-degenes only
    for row in alldata.iterrows():
        if row[0] in nd:
            keep.append(True)
        else:
            keep.append(False)

    seldata = alldata[keep]
    seldata = seldata.sort('total', ascending=False)
    seldata = seldata[seldata['total'] > 0]
    print len(seldata), 'filtered, zero removed, and sorted'
    print seldata.head()

    return seldata # return non-degenes only

def main():
    '''Main function'''
    nondegenes = sys.argv[1]
    colname = sys.argv[2]
    pathdir = sys.argv[3]

    alldata = load_data(pathdir, colname)
    select(alldata, nondegenes).to_csv(
            'sorted-non-degenes-by-total-%s.txt' % colname,
            sep='\t')


if __name__=='__main__':
    main()

