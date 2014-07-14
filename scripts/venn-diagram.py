#!/usr/bin/env python
'''The script plots Venn diagram of orthologs and homologs of two

datasets. Consult Eel pond protocol on how to annotate sequences.
'''

import sys
import matplotlib.pyplot as plt
import csv
from matplotlib_venn import venn2_circles, venn2

def load_annot(csvfile):
    '''Return sets of transcript IDs with homologs and orthologs'''

    homologs = set()
    orthologs = set()
    with open(csvfile) as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if row['ortholog']:
                orthologs.add(row['sequence name'])
            elif row['homolog']:
                homologs.add(row['sequence name'])

    return homologs, orthologs


def main():
    '''Main function'''

    # load data from annotation csv file
    ortho1, homo1 = load_annot(sys.argv[1])
    ortho2, homo2 = load_annot(sys.argv[2])
    print 'Total orthologs = %d, %d' % (len(ortho1), len(ortho2))
    print 'Total homologs = %d, %d' % (len(homo1), len(homo2))

    # create a figure with two columns and one row
    fig = plt.figure(0)
    ax1 = fig.add_subplot(1,2,1)
    ax2 = fig.add_subplot(1,2,2)
    fig.tight_layout()
    font = {'size':18}

    # venn2 input can be numbers or sets
    # if the input is numbers, it has to be in a form of a list with
    # three elements, e.g. [10, 20, 15], where the middle value is the
    # intersection.

    v1 = venn2([ortho1, ortho2],
            set_labels=('C. familiaris', 'M. musculus'), ax=ax1)
    v1.get_patch_by_id('10').set_color('gray')
    v1.get_patch_by_id('01').set_color('gray')
    v1.get_patch_by_id('11').set_color('gray')
    v1.get_patch_by_id('10').set_alpha(0.2)
    v1.get_patch_by_id('01').set_alpha(0.2)
    v1.get_patch_by_id('11').set_alpha(0.5)
    v1.get_label_by_id('10').set_fontsize(15)
    v1.get_label_by_id('01').set_fontsize(15)
    v1.get_label_by_id('11').set_fontsize(15)

    # add diagram title
    ax1.text(-0.15, 0.65, 'Orthologs', fontdict=font)

    # add circles
    c1 = venn2_circles([ortho1, ortho2], linestyle='solid', lw=2.0, ax=ax1)

    v2 = venn2([homo1, homo2],
            set_labels=('C. familiaris', 'M. musculus'), ax=ax2)
    v2.get_patch_by_id('10').set_color('gray')
    v2.get_patch_by_id('01').set_color('gray')
    v2.get_patch_by_id('11').set_color('gray')
    v2.get_patch_by_id('10').set_alpha(0.2)
    v2.get_patch_by_id('01').set_alpha(0.2)
    v2.get_patch_by_id('11').set_alpha(0.5)
    v2.get_label_by_id('10').set_fontsize(15)
    v2.get_label_by_id('01').set_fontsize(15)
    v2.get_label_by_id('11').set_fontsize(15)

    # add diagram title
    ax2.text(-0.1, 0.65, 'Homologs', fontdict=font)

    # add circles
    c2 = venn2_circles([homo1, homo2], linestyle='solid', lw=2.0, ax=ax2)

    # save plot in PDF format
    plt.savefig('dog-mouse-venn.pdf', bbox_inches='tight', pad_inches=0.1)


if __name__=='__main__':
    main()

