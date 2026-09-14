# loading library
library(tidyr) 
library(data.table)

# set working directory
setwd("./GSE40279/")

# load files
results_age <- readRDS("output/limma_analysis/results_age.rds")
results_biological_sex <- readRDS("output/limma_analysis/results_biological_sex.rds")

# results_age is the considered file
# [order(-t)] acts on rows only, it reorders them in a decrescent manner
# [Relation_to_UCSC_CpG_Island == "Island"] keeps only the rows linked to CpG islands
# [grep(i), ...] --> grep("TSS",UCSC_RefGene_Group) --> considering the UCSC_RefGene_Group column, it keeps the CpG islands associated to TSS
# [grep(), .(UCSC_RefGene_Name, t, ID)] --> .() indicates the column to extract, that are UCSC_RefGene_Name, t, ID 
# the result is stored inside age_GSEA
age_GSEA <- results_age[order(-t)][Relation_to_UCSC_CpG_Island == "Island"][grep("TSS", UCSC_RefGene_Group),.(UCSC_RefGene_Name, t, ID)]

# same logic but for biological_sex
biological_sex_GSEA <- results_biological_sex[order(-t)][Relation_to_UCSC_CpG_Island == "Island"][grep("TSS", UCSC_RefGene_Group), .(UCSC_RefGene_Name, t, ID)]

# combineGeneNames <- function(x) { ... } creates a new function that accepts only a single input
# strsplit(x, split = ";") splits the chr string everytime it finds a semicolumn
# [[1]] extracts the first (and only) element of the list and transforms it into a chr vector
# %>% for piping
# unlist() ensures that the element is transformed into chr string
# unique() removes the repeated element in the vector
# paste(.,collapse=";") combines the left gene names together into a chr string using ";" as separator
combineGeneNames <- function(x) {
  strsplit(x,split=";")[[1]] %>% unlist() %>% unique() %>% paste(.,collapse=";")
} 

# age_GSEA[,newGeneName := ...] adds the newGeneName column directly in the data.table 
# combineGeneNames(UCSC_RefGene_Name) takes the elements stored in UCSC_RefGene_Name and pass them to the function combineGeneNames
# by = ID is telling R how to perform the function, in this case it goes row by row considering the ID column
age_GSEA[,newGeneName := combineGeneNames(UCSC_RefGene_Name),by=ID]

#same logic but for biological sex
biological_sex_GSEA[,newGeneName := combineGeneNames(UCSC_RefGene_Name),by=ID]

# fwrite() saves the file 
# fwrite(..., file = "output/age_GSEA.rnk", sep = "\t", col.names = F) 
# ... file = "output/age_GSEA.rnk" saves the file in output folder with the proper name and extension
# ... sep = "\t" sets tab as separator
# ... col.names = F avoids writing column names 
# fwrite(age_GSEA[newGeneName!="" & !grepl(";",newGeneName), ...] --> row filter
# ... newGeneName != "" avoids keeping rows without names 
# ... !grepl(";", newGeneName) --> grepl looks for ";" in the rows, if it finds one, the row is skipped, keeping probes targeting unique genes
# , .(newGeneName, round(t, 3)) --> the first column is the gene name, while the second one contains t values rounded to the third decimal
fwrite(age_GSEA[newGeneName!="" & !grepl(";",newGeneName),.(newGeneName,round(t,3))],
       file = "output/age_GSEA.rnk",sep="\t",col.names = F)

# same logic but with biological sex 
fwrite(biological_sex_GSEA[newGeneName!="" & !grepl(";",newGeneName),.(newGeneName,round(t,3))],
       file = "output/biological_sex_GSEA.rnk",sep="\t",col.names = F) 