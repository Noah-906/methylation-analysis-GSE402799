# loading library
library(data.table)
library(ggplot2)

# loading file
updated_beta_norm <- readRDS("./GSE40279/output/probe_normalization/updated_beta_norm.rds")

# ------------------------------------------------------------------------
#  check if betas are normalized with a subset pt.2 (after normalization)
# ------------------------------------------------------------------------

# melt() transforms the table from wide to long format
# id.vars tells R which columns must NOT be considered by melt()
# measure.vars = colnames(updated_beta_norm)[99:110] is identifying the columns whose values are unrolled
# ...the columns' name are stored into the new "variable" column
# ...the columns' values instead are stored into the new "value" column 
# save in updated_beta_norm_v2 
updated_beta_norm_v2 <- 
  melt(updated_beta_norm, 
       id.vars = c("ID_REF", "Infinium_Design_Type"), measure.vars = colnames(updated_beta_norm)[99:110]
  )

# ggplot(updated_beta_norm_v2) --> tells ggplot the file to consider
# geom_density() --> plot the density distribution
# aes(x = value, ...) --> on x-axis is plotted what is in the "value" column of updated_beta_norm_v2
# aes(..., col = Infinium_Design_Type) --> the density plots of both probes have two different colors
# facet_wrap(~ variable) --> creates a density plot per each sample 
ggplot(updated_beta_norm_v2) + 
     geom_density(aes(x = value, col = Infinium_Design_Type)) +
     facet_wrap(~ variable) 
#result: the betas were normalized successfully 
