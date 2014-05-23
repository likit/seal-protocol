'''The script reads two annotation files from Eel pond protocol and outputs

transcripts in the first file that are not in the second file based on
unique IDs and transcript family IDs.

'''

from pandas import read_csv

mus = read_csv('trinity-mirounga.mouse.fa.annot.csv.fixed', header=0)
dog = read_csv('mirounga-dog.fa.annot.csv', header=0)

dogflt = dog[dog.ortholog.notnull()]
musflt = mus[mus.ortholog.notnull()]

annotdog = set(dogflt['unique ID'].tolist())
annotmus = set(musflt['unique ID'].tolist())

annotdog = set(dogflt['unique ID'].tolist())
annotmus = set(musflt['unique ID'].tolist())

dogonly = set(annotdog).difference(set(annotmus))

print len(dogonly)

idx = []

for row in dogflt.iterrows():
    features = row[1]
    if features['unique ID'] in dogonly:
        idx.append(row[0])

dogonly_table = dog.ix[idx]

dogonly_table.to_csv('dog_annots_only_id.txt')

annotdog = set(dogflt['Transcript family'].tolist())
annotmus = set(musflt['Transcript family'].tolist())

dogonly = set(annotdog).difference(set(annotmus))

print len(dogonly)

idx = []

for row in dogflt.iterrows():
    features = row[1]
    if features['Transcript family'] in dogonly:
        idx.append(row[0])

dogonly_table = dog.ix[idx]

dogonly_table.to_csv('dog_annots_only_family.txt')
