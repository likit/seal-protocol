library(org.Mm.eg.db)
library(GO.db)
ortho <- read.table('ortholog.trinity-mirounga.renamed.fa.annot.csv',
                        sep='\t', stringsAsFactors=F)
homo <- read.table('homolog.trinity-mirounga.renamed.fa.annot.csv',
                        sep='\t', stringsAsFactors=F)

colnames(ortho) <- c("seqid", "desc", "refseq")
colnames(homo) <- c("seqid", "desc", "refseq")
dortho <- select(org.Mm.eg.db, keys=as.vector(ortho$refseq),
                columns=c("SYMBOL", "GO", "PATH"), keytype="REFSEQ")

dhomo <- select(org.Mm.eg.db, keys=ortho$refseq,
                columns=c("SYMBOL", "GO", "PATH"), keytype="REFSEQ")

writeGO <- function(data, category, prefix)
{
  d <- data[data$ONTOLOGY==category,]
  d <- d[!is.na(d$GO),]
  terms = stack(lapply(mget(d$GO, GOTERM), Term))
  d$terms = terms$values
  write.table(d, paste(c(prefix, category, "txt"),
                       collapse="."), sep='\t', quote=F)
}

writeGO(dortho, 'BP', 'mouse.ortholog')
writeGO(dortho, 'MF', 'mouse.ortholog')
writeGO(dortho, 'CC', 'mouse.ortholog')
writeGO(dhomo, 'BP', 'mouse.homolog')
writeGO(dhomo, 'MF', 'mouse.homolog')
writeGO(dhomo, 'CC', 'mouse.homolog')
