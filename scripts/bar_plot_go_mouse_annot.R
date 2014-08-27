library(GO.db)
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
            columns=c("ENSEMBL", "SYMBOL", "ENTREZID", "GO"),
            keytype="REFSEQ")

plot_go <- function(d, term) {
  d <- d[d$ONTOLOGY==term,]
  d <- as.data.frame.table(table(d$GO), stringsAsFactor=FALSE)
  d <- d[order(d$Freq, decreasing=TRUE),]
  topd <- d[1:20,]
  terms = stack(lapply(mget(as.character(topd$Var1), GOTERM), Term))
  topd$terms = terms$values
  
  ggplot(topd, aes(x=reorder(terms, Freq), y=Freq)) +
    theme_bw() +
    geom_bar(stat="identity") +
    coord_flip() +
    geom_text(aes(label=Freq), hjust=1.1, colour='white') +
    labs(list(title=paste("Number of Genes in Top", term, "Terms"),
              x="Terms", y="Number"))
}
png("mouse-annotated-bar-bp-plot.png", width=8, height=7,
    res=300, units='in')
plot_go(d, "BP")
dev.off()