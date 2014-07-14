rsem-degenes-to-kegg:

	qsub -v input="sample1_2.degenes" $(protocol)/scripts/pathway_job.sh
	qsub -v input="sample1_4_7.degenes" $(protocol)/scripts/pathway_job.sh
	qsub -v input="sample2_5_8.degenes" $(protocol)/scripts/pathway_job.sh
	qsub -v input="sample3_6_9.degenes" $(protocol)/scripts/pathway_job.sh
	qsub -v input="sample4_5.degenes" $(protocol)/scripts/pathway_job.sh
	qsub -v input="sample7_8.degenes" $(protocol)/scripts/pathway_job.sh

sort-non-degenes-by-expected-count:

	python $(protocol)/scripts/sort-non-degenes-by-col.py \
		non-degenes.txt expected_count .

annotate-mouse-unannotated-seq:

	python $(eelprotocol)/make-uni-best-hits.py mian.x.mammals \
		mian.x.mammals.homol
	python $(eelprotocol)/make-reciprocal-best-hits.py mian.x.mammals \
		mammals.x.mian mian.x.mammals.ortho

plot-venn-diagram:

	python $(protocol)/scripts/venn-diagram.py \
		mirounga-dog.fa.annot.csv trinity-mirounga.mouse.fa.annot.csv.fixed
