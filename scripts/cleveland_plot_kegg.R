library(ggplot2)
pathways = read.table('sample1_4_7.pathway.txt', sep='\t', header=T)
pathways$log10Bonf = (-1)*log10(pathways$Bonferroni)
pathways$sample="0vs2hrs"
pdf("sample1_4_7.KEGG.plot.pdf", width=8, height=7)
ggplot(pathways, aes(x=log10Bonf, y=reorder(Term, log10Bonf))) +
  geom_point(aes(size=Count, colour=sample)) +
  theme_bw() +
  scale_colour_brewer(palette="Set1") +
  scale_size(range=c(3,10)) +
  labs(list(title="Enriched KEGG Pathways",
              x=expression(paste(-log[10](Bonferroni))), y="Pathway")) +
  guides(colour=F)
dev.off()

