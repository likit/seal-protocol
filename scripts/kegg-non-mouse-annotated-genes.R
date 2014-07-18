library(org.Mm.eg.db)
library(GO.db)
library(goseq)
library(KEGG.db)
ortho <- read.table('ortholog.trinity-mirounga.renamed.fa.annot.csv',
                    sep='\t', stringsAsFactors=F)
homo <- read.table('homolog.trinity-mirounga.renamed.fa.annot.csv',
                   sep='\t', stringsAsFactors=F)

colnames(ortho) <- c("seqid", "desc", "refseq")
colnames(homo) <- c("seqid", "desc", "refseq")
d <- rbind(ortho, homo)
#dortho <- select(org.Mm.eg.db, keys=as.vector(ortho$refseq),
#                 columns=c("ENSEMBL", "SYMBOL", "GO", "PATH"),
#                 keytype="REFSEQ")

#dhomo <- select(org.Mm.eg.db, keys=ortho$refseq,
#                columns=c("ENSEMBL", "SYMBOL", "GO", "PATH"),
#                keytype="REFSEQ")

d <- select(org.Mm.eg.db, keys=as.vector(d$refseq),
                 columns=c("ENSEMBL", "SYMBOL", "ENTREZID", "PATH"),
                 keytype="REFSEQ")

d <- d[!is.na(d$ENSEMBL),]
d <- d[!duplicated(d$ENSEMBL),]

mart<-useMart(biomart="ensembl", dataset="mmusculus_gene_ensembl")
allgenes<-getBM(attributes='ensembl_gene_id', mart=mart)
allgenes<-allgenes$ensembl_gene_id

gene.vector<-as.integer(allgenes%in%d$ENSEMBL)
names(gene.vector)<-allgenes

pwf=nullp(gene.vector, 'mm9', 'ensGene')
# KEGG Pathway analysis
KEGG = goseq(pwf, "mm9", "ensGene", test.cats="KEGG")

# Adjust P-value using BH method
KEGG$padjust = p.adjust(KEGG$over_represented_pvalue, method="BH")

KEGG.sig = KEGG[KEGG$padjust<0.05,]
pathway = stack(mget(KEGG.sig$category, KEGGPATHID2NAME))
KEGG.sig$pathway = pathway$values
KEGG.sig$padjust <- format(KEGG.sig$padjust, scientific=T)
write.table(KEGG.sig[, c("category", "numDEInCat", "padjust", "pathway")],
            'mouse-annotated-kegg.txt', sep='\t', quote=F,
            row.names=F)

KEGG_SIG = KEGG[KEGG$padjust<0.05,]
pathway = stack(mget(KEGG[KEGG$padjust<0.05,]$category, KEGGPATHID2NAME))
KEGG_SIG$pathway = pathway$values

xx = as.list(org.Mm.egPATH2EG)
xx = xx[!is.na(xx)] # remove KEGG IDs that do not match any gene

# Write genes in each pathway to separate files
get_genes_kegg = function(c, data, prefix)
{
  m = match(xx[[c]], data$ENTREZID)
  mm = m[!is.na(m)]
  d = data.frame(c, data[mm,]$REFSEQ, data[mm,]$ENSEMBL,
                 data[mm,]$ENTREZID, data[mm,]$SYMBOL)
  
  filename = paste(prefix, c, sep="_")
  write.table(d, filename, sep="\t", row.names=F, col.names=F, quote=F)
  return(d)
}
df <- lapply(head(KEGG_SIG, n=20)$category,
             get_genes_kegg,
            d, "mouse-annot-kegg")

write.table(d, 'mouse-annotated-ensembl.txt', sep='\t',
            quote=T, row.names=F,
            )
