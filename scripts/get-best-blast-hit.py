import sys
import csv

curr_query = None
with open(sys.argv[1]) as fp:
    reader = csv.reader(fp, dialect='excel-tab')
    writer = csv.writer(sys.stdout, dialect='excel-tab')
    for row in reader:
        query = row[0]
        subj = row[1].split('|')[1]
        # bitscore = row[-1]
        if not curr_query:
            curr_query = query
        elif curr_query == query:
            continue
        else:
            curr_query = query

        writer.writerow([subj])
