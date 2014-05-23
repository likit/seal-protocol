# The scripts reads a file from annotation step in Eel pond protocol and finds a gene symbol for each gene.
# The output include ENSEMBL, symbol and Entrez ID.

get.ensbl.id <- function(ortholog) {
  geneid <- strsplit(ortholog, ' ')[[1]][3]
  geneid <- strsplit(geneid, ':')[[1]][2]
  return(geneid)
}
library("org.Cf.eg.db")

#mart<-useMart(biomart="ensembl", dataset="cfamiliaris_gene_ensembl")
#allgenes<-getBM(attributes=c('ensembl_gene_id', 'entrezgene', 'description'), mart=mart)

dog <- read.csv('dog_annots_only_id.txt', header=T, stringsAsFactor=F)
dog$ENSEMBL<-sapply(dog$ortholog, get.ensbl.id)

symbs<-select(org.Cf.eg.db, keys=dog$ENSEMBL, keytype="ENSEMBL", columns=c("SYMBOL", "ENTREZID"))

d<-merge(dog, symbs, by.x="ENSEMBL", by.y="ENSEMBL", all.x=T)
write.table(d[,c(1,3,4,5,12,13)], 'dog_annots_only_id_with_symbol.txt', sep='\t', quote=F, col.names=TRUE)