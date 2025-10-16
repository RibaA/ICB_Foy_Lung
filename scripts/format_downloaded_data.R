## load libraries

library(GEOquery)
library(data.table)
library(readxl)
library(readr)
library(stringr)

args <- commandArgs(trailingOnly = TRUE)
#work_dir <- args[1]
work_dir <- "data"

# CLIN.txt
gse <- getGEO("GSE161537", GSEMatrix = TRUE, AnnotGPL = TRUE)
dat <- gse[[1]]

# Extract clinical/phenotype (metadata / sample info)
clin <- pData(dat)
clin <- as.data.frame(clin)
clin <- clin[order(rownames(clin)), ]

# EXP_TPM.tsv 
expr <- read_tsv( file = file.path(work_dir, "GSE161537_norm_counts_TPM_GRCh38.p13_NCBI.tsv") ) 
expr <- as.data.frame(expr)
expr <- expr[order(expr$GeneID), ]
rownames(expr) <- expr$GeneID
expr <- expr[, -1]
expr <- expr[, order(colnames(expr))]

# samples with both clinical and expression data
int <- intersect(rownames(clin), colnames(expr))
clin <- clin[rownames(clin) %in% int, ]

write.table(clin, file=file.path(work_dir, 'CLIN.txt'), sep = "\t" , quote = FALSE , row.names = FALSE)

expr <- expr[, colnames(expr) %in% int]
write.table(expr, file=file.path(work_dir, 'EXP_TPM.tsv'), sep = "\t" , quote = FALSE , row.names = TRUE, col.names=TRUE)
