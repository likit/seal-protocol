library(org.Mm.eg.db)

ortho <- read.table('ortholog.trinity-mirounga.renamed.fa.annot.csv',
                        sep='\t', stringsAsFactors=F)
homo <- read.table('homolog.trinity-mirounga.renamed.fa.annot.csv',
                        sep='\t', stringsAsFactors=F)

dortho <- select(org.Mm.eg.db, keys=ortho$refseq,
                columns=c("SYMBOL", "GO", "PATH"), keytype="REFSEQ")

dhomo <- select(org.Mm.eg.db, keys=ortho$refseq,
                columns=c("SYMBOL", "GO", "PATH"), keytype="REFSEQ")

terms = stack(lapply(mget(MF[MF$padjust<0.05,]$category, GOTERM), Term))
MF_SIG$terms = terms$values
xx = as.list(org.Gg.egPATH2EG)
xx = xx[!is.na(xx)] # remove MF IDs that do not match any gene


get_genes_MF = function(cat, data, prefix)
{
    m = match(xx[[cat]], data$ENTREZID)
    mm = m[!is.na(m)]
    d = data.frame(cat, data[mm,]$geneID, data[mm,]$ENTREZID)

    filename = paste(prefix, cat, sep="_")
    write.table(d, filename, sep="\t", row.names=F, col.names=F, quote=F)
    return(d)
}

df = lapply(MF_SIG$category, get_genes_MF,
uniq.annotated.degenes, "line6_goseq_MF_genes")

# Get number of genes in each pathway
#MF_SIG$ngenes = sapply(df, nrow) # get a number of genes from each category
