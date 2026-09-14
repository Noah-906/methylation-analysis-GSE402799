# loading libraries
library(data.table)
library(ggplot2)

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

# ---------------------------------------------
#  check if betas are normalized with a subset
# ---------------------------------------------

# melt() transforms the table from wide to long format
# id.vars tells R which columns must NOT be considered by melt()
# measure.vars = colnames(updated_autosomal_betas)[99:110] is identifying the columns whose values are unrolled
# ...the columns' name are stored into the new "variable" column
# ...the columns' values instead are stored into the new "value" column 
# save in updated_autosomal_betas_v2 
updated_autosomal_betas_v2 <-
  melt(updated_autosomal_betas, 
       id.vars = c("ID_REF", "Infinium_Design_Type"), measure.vars = colnames(updated_autosomal_betas)[99:110])

# ggplot(updated_autosomal_betas_v2) --> tells ggplot the file to consider
# geom_density() --> plot the density distribution
# aes(x = value, ...) --> on x-axis is plotted what is in the "value" column of updated_autosomal_betas_v2
# aes(..., col = Infinium_Design_Type) --> the density plots of both probes have two different colors
# facet_wrap(~ variable) --> creates a density plot per each sample 
ggplot(updated_autosomal_betas_v2) +
  geom_density(aes(x = value, col = Infinium_Design_Type)) +
  facet_wrap(~ variable)
#result: the betas were not normalized
