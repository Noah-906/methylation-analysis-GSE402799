# loading libraries
library(data.table)

# set working directory
setwd("./GSE40279/")

# load files
results_age <- readRDS("output/limma_analysis/results_age.rds")
results_biological_sex <- readRDS("output/limma_analysis/results_biological_sex.rds")

# results_age[, ...] considers all the rows of results_age
# aov(logFC ~ Relation_to_UCSC_CpG_Island) performs anova test on the two designed results_age column
# ... logFC is the dependent variable because its value may depend on Relation_to_UCSC_CpG_Island 
# ... Relation_to_UCSC_CpG_Island is the independent variable
# |> is the pipe symbol
# TukeyHSD() performs a pairwise comparison for each group in the anova test to understand in which couple(s) there is a significant difference

results_age[, aov(logFC ~ Relation_to_UCSC_CpG_Island)] |> TukeyHSD() # pairwise differences between groups

# same logic but for results_biological_sex
results_biological_sex[, aov(logFC ~ Relation_to_UCSC_CpG_Island)] |> TukeyHSD() # pairwise differences between groups

