rsem-degenes-to-kegg:

	qsub -v input="0hr_vs_24hr.degenes" $(protocol)/scripts/pathway_job.sh
	qsub -v input="0hr_vs_2hr.degenes" $(protocol)/scripts/pathway_job.sh
	qsub -v input="2hr_vs_24hr.degenes" $(protocol)/scripts/pathway_job.sh

sort-non-degenes-by-expected-count:

	python $(protocol)/scripts/sort-non-degenes-by-col.py \
		non-degenes.txt expected_count .

annotate-mouse-unannotated-seq:

	python $(eelpond)/make-uni-best-hits.py mian.x.mammals \
		mian.x.mammals.homol
	python $(eelpond)/make-reciprocal-best-hits.py mian.x.mammals \
		mammals.x.mian mian.x.mammals.ortho

plot-venn-diagram:

	python $(protocol)/scripts/venn-diagram.py \
		mirounga-dog.fa.annot.csv trinity-mirounga.mouse.fa.annot.csv.fixed

reciprocal-blast-human:

	qsub -v input=human.protein_5000.fa $(protocol)/scripts/blast-human-seal.sh

create-db:

	python $(eelpond)/make-namedb.py human.protein.faa human.namedb
	python -m screed.fadbm human.protein.faa

annotate-transcripts-human:

	python $(eelpond)/make-uni-best-hits.py mian.x.human mian.x.human.homol
	python $(eelpond)/make-reciprocal-best-hits.py mian.x.human \
		human.x.mian mian.x.human.ortho
	python $(eelpond)/annotate-seqs.py trinity-mirounga.renamed.fa \
		mian.x.human.ortho mian.x.human.homol

annotate-transcripts-mouse:

	# python $(eelpond)/make-uni-best-hits.py mian.x.mouse mian.x.mouse.homol
	# python $(eelpond)/make-reciprocal-best-hits.py mian.x.mouse \
	# 	mouse.x.mian mian.x.mouse.ortho
	python $(eelpond)/annotate-seqs.py trinity-mirounga.renamed.fa \
		mian.x.mouse.ortho mian.x.mouse.homol
