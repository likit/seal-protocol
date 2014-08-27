library(KEGG.db)
library(ggplot2)
library(org.Mm.eg.db)

ortho <- read.table('ortholog.trinity-mirounga.renamed.fa.annot.csv',
                    sep='\t', stringsAsFactors=F)
homo <- read.table('homolog.trinity-mirounga.renamed.fa.annot.csv',
                   sep='\t', stringsAsFactors=F)

colnames(ortho) <- c("seqid", "desc", "refseq")
colnames(homo) <- c("seqid", "desc", "refseq")
d <- rbind(ortho, homo)

d <- select(org.Mm.eg.db, keys=as.vector(d$refseq),
            columns=c("ENSEMBL", "SYMBOL", "ENTREZID", "PATH"),
            keytype="REFSEQ")

td <- as.data.frame.table(table(d$PATH), stringsAsFactor=FALSE)
td <- td[order(td$Freq, decreasing=TRUE),]
# td <- td[!is.na(td$Var1),]
toptd <- td[1:20,]
pathway = stack(mget(as.character(toptd$Var1), KEGGPATHID2NAME))
toptd$pathway = pathway$values
png("mouse-annotated-kegg-bar-plot.png",
    res=300, units='in',
    width=8, height=7)
ggplot(toptd, aes(x=reorder(pathway, Freq), y=Freq)) +
  theme_bw() +
  geom_bar(stat="identity") +
  coord_flip() +
  geom_text(aes(label=Freq), hjust=1.1, colour='white') +
  labs(list(title="Number of Genes in Top KEGG Pathways",
            x="Pathway", y="Number"))
dev.off()
