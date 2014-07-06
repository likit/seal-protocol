rsem-degenes-to-kegg:

	qsub -v input="sample1_2.degenes" ~/seal-protocol/scripts/pathway_job.sh
	qsub -v input="sample1_4_7.degenes" ~/seal-protocol/scripts/pathway_job.sh
	qsub -v input="sample2_5_8.degenes" ~/seal-protocol/scripts/pathway_job.sh
	qsub -v input="sample3_6_9.degenes" ~/seal-protocol/scripts/pathway_job.sh
	qsub -v input="sample4_5.degenes" ~/seal-protocol/scripts/pathway_job.sh
	qsub -v input="sample7_8.degenes" ~/seal-protocol/scripts/pathway_job.sh

sort-non-degenes-by-expected-count:

	python scripts/sort-non-degenes-by-col.py non-degenes.txt expected_count .
