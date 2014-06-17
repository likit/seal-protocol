# The scripts reads a file from annotation step in Eel pond protocol and finds a gene symbol for each gene.
# The output include ENSEMBL, symbol and Entrez ID.

library("org.Cf.eg.db")

getEnsblId <- function(homolog) {
  geneid <- strsplit(homolog, ' ')[[1]][3]
  geneid <- strsplit(geneid, ':')[[1]][2]
  return(geneid)
}

dog <- read.csv('dog_annots_only_id.txt', header=T,
                stringsAsFactor=F)

dog_ortholog = dog[which(dog$ortholog != ""), ]
dog_homolog = dog[which(dog$homolog != ""), ]

dog_ortholog$ENSEMBL <- sapply(dog_ortholog$ortholog, getEnsblId)
dog_homolog$ENSEMBL <- sapply(dog_homolog$homolog, getEnsblId)

ortho_symbs <- select(org.Cf.eg.db, keys=dog_ortholog$ENSEMBL,
                      keytype="ENSEMBL", columns=c("SYMBOL", "ENTREZID"))
homo_symbs <- select(org.Cf.eg.db, keys=dog_homolog$ENSEMBL,
                     keytype="ENSEMBL", columns=c("SYMBOL", "ENTREZID"))

dortho <- merge(dog_ortholog, ortho_symbs, by.x="ENSEMBL", by.y="ENSEMBL", all.x=T)
dhomo <- merge(dog_homolog, homo_symbs, by.x="ENSEMBL", by.y="ENSEMBL", all.x=T)
write.table(dortho[,c(1,3,4,5,12,13)],
            'dog_orthologs_only_id_with_symbol.txt',
            sep='\t', quote=F, col.names=TRUE)

write.table(dhomo[,c(1,3,4,5,12,13)],
            'dog_homologs_only_id_with_symbol.txt',
            sep='\t', quote=F, col.names=TRUE)

alldog <- read.csv('mirounga-dog.fa.annot.csv', header=T,
                stringsAsFactor=F)
alldog.flt <- alldog[which(alldog$ortholog != "" |
                             alldog$homolog != ""),]

alldog.flt$ENSEMBL <- sapply(alldog.flt$ortholog, getEnsblId)
alldog.flt$ENSEMBL <- sapply(alldog.flt$homolog, getEnsblId)

symbs <- select(org.Cf.eg.db, keys=alldog.flt$ENSEMBL,
                keytype="ENSEMBL",
                columns=c("SYMBOL", "ENTREZID"))

d <- merge(alldog.flt, symbs, by.x="ENSEMBL", by.y="ENSEMBL", all.x=T)
write.table(d[,c(1,2,3,4,11,12)], 'dog_annots_all_id_with_symbol.txt',
                sep='\t', quote=F, col.names=TRUE)
