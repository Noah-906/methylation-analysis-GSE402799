# loading libraries

library(data.table)
library(wateRmelon)

# set proper directory
setwd("./GSE40279/output/probe_normalization/")

# loading needed files 
beta_values_autosomal <- readRDS("./GSE40279/output/beta_values_autosomal.rds")
manifest <- fread("./GSE40279/files/GPL/GPL13534-11288.txt")

# merge() --> for every row of beta_values_autosomal (x), search the respective probe in manifest (y)
# ...and attaches the correspondant Infinium_Design_Type (type I or type II probes)
# by.x = "ID_REF", by.y = "ID" --> indicates the columns in which R needs to look for the merging
# save in updated_autosomal_betas 
updated_autosomal_betas <- 
  merge(beta_values_autosomal, manifest[, .(ID, Infinium_Design_Type)],
 by.x = "ID_REF", by.y = "ID")

#---------------------------------------
# BMIQ normalization / data preparation 
#---------------------------------------

# updated_autosomal_betas[, ...] --> keeping all rows
# [, ifelse(Infinium_Design_Type == "I", 1, 2)] --> if Infinium_Design_Type == "I", write 1, otherwise, write 2 (condition for column)
# design.v --> it's a vector containing every design type (its str is 2 2 1 2 2 1 ...)
design.v <- updated_autosomal_betas[, ifelse(Infinium_Design_Type == "I", 1, 2)]

# updated_autosomal_betas[, 2:657, with = FALSE] --> keeping all rows, selection of columns from 2 to 657
# as.matrix --> conversion of that columns' portion into a matrix
beta_matrix <- as.matrix(updated_autosomal_betas[, 2:657, with = FALSE])

#assigning CpGs' names (ID_REF) to beta_matrix rownames
rownames(beta_matrix) <- updated_autosomal_betas$ID_REF

#check if there are missing values
anyNA(beta_matrix) # should return FALSE

# identical() checks the order of CpGs' names
# ...useful to check if there is a misalignment between beta_matrix rownames and ID_REF of updated_autosomal_betas
identical(updated_autosomal_betas$ID_REF, rownames(beta_matrix)) # should return TRUE
# my result: TRUE 

# matrix() --> create a new matrix
# NA_real_ --> NA_ fills the matrix temporary with NA, real_ tells R that the spaces will be filled with real decimal numbers
# nrow = nrow(beta_matrix) --> same number of rows of beta_matrix
# ncol = ncol(beta_matrix) --> same number of cols of beta_matrix
# rownames(beta_normalized) <- rownames(beta_matrix) --> assign the beta_matrix rownames to the new empty one
# colnames(beta_normalized) <- colnames(beta_matrix) --> assign the beta_matrix colnames to the new empty one
beta_normalized <- matrix(NA_real_, nrow = nrow(beta_matrix), ncol = ncol(beta_matrix))
rownames(beta_normalized) <- rownames(beta_matrix)
colnames(beta_normalized) <- colnames(beta_matrix)

#----------------------------------
# BMIQ normalization / application 
#----------------------------------

# for (i in 1:ncol(beta_matrix)) { --> a loop that is repeated for all the beta_matrix columns
# ... everything in {} will be executed for 656 times
# beta.v <- beta_matrix[, i] --> store all the beta values for each CpG of a single sample
# ...i becomes a different samples everytime the for cycle is repeated
# bmiq_result <- BMIQ(...) --> the BMIQ normalization is applied to beta.v, guided by design.v for probe type info
# beta_normalized[, i] <- bmiq_result$nbeta --> BMIQ stores normalized betas into nbeta column by default...
# these normalized value fill the column of the respective sample analysed (i) 
for (i in 1:ncol(beta_matrix)) { 
  
 
  beta.v <- beta_matrix[, i]
  
  
  bmiq_result <- BMIQ(beta.v, design.v)
  
 
  beta_normalized[, i] <- bmiq_result$nbeta
  

  if (i %% 10 == 0) {
    message("Normalized sample ", i, " of ", ncol(beta_matrix), " (", colnames(beta_matrix)[i], ")")
  }
} 

#my results:
#i = 656
#design.v contains 470043 values
#beta.v contains 470043 values

# save outcome of bmiq normalization
saveRDS(beta_normalized, file = "beta_normalized.rds") 

# as.data.table() --> transform beta_normalized (a matrix) into a data.table
# keep.rownames = "ID_REF" --> save matrix rownames into a new column (belonging to beta_norm_dt) called "ID_REF"
beta_norm_dt <- as.data.table(beta_normalized, keep.rownames = "ID_REF")

# merge() --> for every row of beta_norm_dt (x), search the respective probe in manifest (y)
# ...and attaches the correspondant Infinium_Design_Type (type I or type II probes)
# by.x = "ID_REF", by.y = "ID" --> indicates the columns in which R needs to look for the merging
# save in updated_beta_norm 
updated_beta_norm <- 
  merge(beta_norm_dt, manifest[, .(ID, Infinium_Design_Type)],
 by.x = "ID_REF", by.y = "ID"
)

saveRDS(updated_beta_norm, file = "updated_beta_norm.rds") 
