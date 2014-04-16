import csv
import sys

with open(sys.argv[1]) as fp:
    reader = csv.reader(fp)
    writer = csv.writer(sys.stdout, dialect="excel-tab")
    for line in reader:
        if line[0] == "sequence name":
            continue
        elif line[5] == '':
            continue
        else:
            writer.writerow(line[0], line[1],
                    line[2], line[3], line[5])
            break

