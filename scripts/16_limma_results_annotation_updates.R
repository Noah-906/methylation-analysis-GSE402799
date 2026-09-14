# loading libraries
library(data.table)

# set work directory
setwd("./GSE40279")

# load files
results_age <- readRDS("output/limma_analysis/results_age.rds") 
results_biological_sex <- readRDS("output/limma_analysis/results_biological_sex.rds")

# results_age[i, j] is the considered data.table
# [Relation_to_UCSC_CpG_Island...] indicates the column of interest in the data.table (i)
# %in% verifies if in the selected column there are the values specified by the vector c("N_Shore", "S_Shore")
# , -> separates the column's filter condition (i) on the left, from the operation to execute (j) on the right
# Relation_to_UCSC_CpG_Island := "Shore" -> the modification to apply if in the selected column there is either "N_Shore" or "S_Shore" chr labels
# := modifies the column in place without creating another data.table
# ... so if there are either one of the two labels, this function modifies the chr string into "Shore"
results_age[Relation_to_UCSC_CpG_Island %in% c("N_Shore", "S_Shore"), Relation_to_UCSC_CpG_Island := "Shore"]

# same logic but for c("N_Shelf", "S_Shelf") labels
results_age[Relation_to_UCSC_CpG_Island %in% c("N_Shelf", "S_Shelf"), Relation_to_UCSC_CpG_Island := "Shelf"]

# same logic of results_age but for results_biological_sex file
results_biological_sex[Relation_to_UCSC_CpG_Island %in% c("N_Shore", "S_Shore"), Relation_to_UCSC_CpG_Island := "Shore"]
results_biological_sex[Relation_to_UCSC_CpG_Island %in% c("N_Shelf", "S_Shelf"), Relation_to_UCSC_CpG_Island := "Shelf"]

saveRDS(results_age, file = "output/limma_analysis/results_age.rds")
saveRDS(results_biological_sex, file = "output/limma_analysis/results_biological_sex.rds") 





