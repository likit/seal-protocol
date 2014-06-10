'''The script reads two annotation files from Eel pond protocol and outputs

transcripts in the first file that are not in the second file based on
unique IDs and transcript family IDs.

'''

from pandas import read_csv

mus = read_csv('trinity-mirounga.mouse.fa.annot.csv.fixed', header=0)
dog = read_csv('mirounga-dog.fa.annot.csv', header=0)

# removed transcripts with no orthologs
dog_ortho = dog[dog.ortholog.notnull()]
dog_homo = dog[dog.homolog.notnull()]

mus_ortho = mus[mus.ortholog.notnull()]
mus_homo = mus[mus.homolog.notnull()]

annotdog = set(dog_ortho['unique ID'].tolist())
annotdog.update(set(dog_homo['unique ID'].tolist()))

annotmus = set(mus_ortho['unique ID'].tolist())
annotmus.update(set(mus_homo['unique ID'].tolist()))

dogonly = set(annotdog).difference(set(annotmus))

# print the number of unique transcripts
print 'unique transcript = ', len(dogonly)

idx = []

for row in dog.iterrows():
    features = row[1]
    if features['unique ID'] in dogonly:
        idx.append(row[0])

dogonly_table = dog.ix[idx]

dogonly_table.to_csv('dog_annots_only_id.txt')

annotdog = set(dog_ortho['Transcript family'].tolist())
annotdog.update(set(dog_homo['Transcript family'].tolist()))
annotmus = set(mus_ortho['Transcript family'].tolist())
annotmus.update(set(mus_homo['Transcript family'].tolist()))

dogonly = set(annotdog).difference(set(annotmus))

# print the number of unique transcripts
print 'unique family = ', len(dogonly)

idx = []

for row in dog.iterrows():
    features = row[1]
    if features['Transcript family'] in dogonly:
        idx.append(row[0])

dogonly_table = dog.ix[idx]

dogonly_table.to_csv('dog_annots_only_family.txt')
