'''The script reads two annotation files from Eel pond protocol and outputs

transcripts in the first file that are not in the second file based on
unique IDs and transcript family IDs.

'''

from pandas import read_csv

mus = read_csv('trinity-mirounga.mouse.fa.annot.csv.fixed', header=0)
dog = read_csv('mirounga-dog.fa.annot.csv', header=0)

# removed transcripts with no orthologs
dog_ortho = dog[dog.ortholog.notnull()]

# removed transcripts with no homologs
dog_homo = dog[dog.homolog.notnull()]

# removed transcripts with no orthologs
mus_ortho = mus[mus.ortholog.notnull()]

# removed transcripts with no homologs
mus_homo = mus[mus.homolog.notnull()]

annot_dog = set(dog_ortho['unique ID'].tolist())
annot_dog.update(set(dog_homo['unique ID'].tolist()))

annot_mus = set(mus_ortho['unique ID'].tolist())
annot_mus.update(set(mus_homo['unique ID'].tolist()))

dog_only = annot_dog.difference(annot_mus)

# print the number of unique transcripts
print 'unique transcript = ', len(dog_only)

idx = []

for row in dog.iterrows():
    features = row[1]
    if features['unique ID'] in dog_only:
        idx.append(row[0])

dog_only_table = dog.ix[idx]

dog_only_table.to_csv('dog_annots_only_id.txt')

annot_dog = set(dog_ortho['Transcript family'].tolist())
annot_dog.update(set(dog_homo['Transcript family'].tolist()))
annot_mus = set(mus_ortho['Transcript family'].tolist())
annot_mus.update(set(mus_homo['Transcript family'].tolist()))

dog_only = set(annot_dog).difference(set(annot_mus))

# print the number of unique transcripts
print 'unique family = ', len(dog_only)

idx = []

for row in dog.iterrows():
    features = row[1]
    if features['Transcript family'] in dog_only:
        idx.append(row[0])

dog_only_table = dog.ix[idx]

dog_only_table.to_csv('dog_annots_only_family.txt')
