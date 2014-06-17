'''The script reads an annotation files from Eel

pond protocol and outputs unannotated transcripts.
'''
import sys
from pandas import read_csv
from Bio import SeqIO

def main():

    seq = read_csv(sys.argv[1], header=0)

    # removed transcripts with no orthologs
    seq_ortho = seq[seq.ortholog.notnull()]

    # removed transcripts with no homologs
    seq_homo = seq[seq.homolog.notnull()]

    annot_seq = set(seq_ortho['unique ID'].tolist())
    annot_seq.update(set(seq_homo['unique ID'].tolist()))

    # print the number of unique transcripts
    print >> sys.stderr, 'annotated transcript = ', len(annot_seq)

    idx = []
    unannot_seqs = set()

    for row in seq.iterrows():
        features = row[1]
        if features['unique ID'] not in annot_seq:
            idx.append(row[0])
            unannot_seqs.add(features['sequence name'])

    # unannot_table = seq.ix[idx]

    print >> sys.stderr, 'unannotated transcript = ', len(unannot_seqs)

    for rec in SeqIO.parse(sys.argv[2], 'fasta'):
        if rec.id in unannot_seqs:
            SeqIO.write(rec, sys.stdout, 'fasta')

    # unannot_table.to_csv(sys.stdout)


if __name__=='__main__':
    main()
