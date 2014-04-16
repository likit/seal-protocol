import csv
import sys

with open(sys.argv[1]) as fp:
    reader = csv.reader(fp, dialect="csv")
    for line in reader:
        print line
        break

