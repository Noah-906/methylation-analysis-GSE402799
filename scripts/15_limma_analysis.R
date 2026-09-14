# loading libraries
library(limma)
library(data.table)
library(tidyr)

# set working directory
setwd("./GSE40279/")

# loading files
phenotype_table <- readRDS("output/phenotype_data/phenotype_table.rds")
updated_beta_norm <- readRDS("output/probe_normalization/updated_beta_norm.rds")


# ----------------------
#   DATA PREPARATION
# ----------------------

# phenotype_table[] --> for the sake of code reproducibility, it indicates a subset of samples in phenotype_table
# ...in this experiment, all the samples are considered without sub-setting 
phenotype_subset <- phenotype_table[]

# phenotype_subset[, ID] selects the ID of all the rows (samples) creating a vector stored in cols_to_keep
cols_to_keep <- phenotype_subset[, ID]

# updated_beta_norm[, ..cols_to_keep] --> selects only columns corresponding to the ID's updated_beta_norm
# .. tells R that cols_to_keep is an external variable, outside the data.table
# |> as.matrix() transforms the result into a matrix
# the matrix is stored into beta_subset
beta_subset <- updated_beta_norm[, ..cols_to_keep] |> as.matrix()

#considers the ID_REF column of updated_beta_norm and sets it as beta_subset rownames
rownames(beta_subset) <- updated_beta_norm$ID_REF

# ~ age + biological_sex --> tells R to consider both age and biological sex as model's covariates 
# data = phenotype_subset --> specifies to R from which dataset it should take the covariates columns
# model.matrix converts the covariates:
# ...age covariate doesn't change because it's stored as numeric variable
# ...biological sex covariate is converted to 0 if it's a female, and to 1 if it's a male
design <- model.matrix(~ age + biological_sex, data = phenotype_subset)

# ----------------------------------------------------
# LIMMA ANALYSIS - W/OUT BETWEEN ARRAYS NORMALIZATION
# ----------------------------------------------------

# lmFit(...) calculates a linear regression for each probe, evaluating how the methylation changes based on age and biological sex
# lmFit result is a coefficient (effect estimation) and error estimation for each probe
# eBayes(...) corrects the results, making p-values and other parameters more reliable and precise
# ... it avoids that small random fluctiations could be interpreted as biologically relevant
fitB <- lmFit(beta_subset, design) %>% eBayes

# topTable extracts and order the genes, showing at the beginning the most statistically relevant for the age variable
topTable(fitB,"age")

# draw a volcano plot
volcanoplot(fitB,"age")

#same logic but for biological sex parameter
topTable(fitB,"biological_sexM")
volcanoplot(fitB, "biological_sexM")

# topTable(fitB,"age",number = Inf)--> number = Inf takes all the probes considered in the experiment, not just the first 10
# as.data.table converts the topTable into a data.table
# keep.rownames = "ID" --> since topTable assigns the probes' ID as rownames, this function creates a new "ID" column with the old rownames 
# merge(..., manifest) combines the data.table with the manifest through the shared ID column
merge(as.data.table(topTable(fitB, "age", number = Inf), keep.rownames = "ID"),
      manifest) -> results_age

# the same logic but for biological sex
merge(as.data.table(topTable(fitB, "biological_sexM", number = Inf), keep.rownames = "ID"),
      manifest) -> results_biological_sex

# reorder the results from the smallest adj.P.Val to the biggest one
results_age[order(adj.P.Val)]

# same reordering but for biological sex
results_biological_sex[order(adj.P.Val)]

# save files
saveRDS(results_age, file = "output/limma_analysis/results_age.rds")
saveRDS(results_biological_sex, file = "output/limma_analysis/results_biological_sex.rds") 
