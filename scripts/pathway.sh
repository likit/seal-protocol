rsem-control-fdr $1 0.05 $1.fdr
python ~/seal-protocol/scripts/rsem-output-to-fasta.py $1.fdr trinity-mirounga.renamed.fa > $1.fdr.fa
python ~/seal-protocol/scripts/gene-rep.py $1.fdr.fa > $1.fdr.rep.fa
blastall -i $1.fdr.rep.fa -d mouse.protein.faa -e 1e-3 -p blastx -o $1.fdr.rep.x.mouse.blast -m 8 -a 8 -v 4 -b 4
python /mnt/home/preeyano/seal-protocol/scripts/get-best-blast-hit.py $1.fdr.rep.x.mouse.blast > $1.fdr.rep.x.mouse.gi.txt
