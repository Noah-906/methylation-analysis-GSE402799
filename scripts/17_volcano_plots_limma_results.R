# loading library
library(ggplot2)

# set working directory
setwd("./GSE40279/") 

# load files
results_age <- readRDS("output/limma_analysis/results_age.rds") 
results_biological_sex <- readRDS("output/limma_analysis/results_biological_sex.rds")

# ggplot(results_age[adj.P.Val < 1e-5]) --> considers adj.P.Val column of results_age and filters it, keeping only the CpGs with adj.P.Val < 1e-5
# aes(logFC,-log10(P.Value)) indicates how the values are spread on cartesian axis
# logFC is the x-axis parameter, indicates how methylation levels change with ageing
# -log10(P.Value) is the y-axis parameter, it calculates the -log10 of P.value, so that the most statistically significant CpGs are on the top of the plot
# geom_point(aes(color = Relation_to_UCSC_CpG_Island),size=1) --> size = 1 sets the size of each dot
# ... aes(color = Relation_to_UCSC_CpG_Island) assign to each Relation_to_UCSC_CpG_Island category a specific color
# theme_bw() applies the white default background with a grey grid
# facet_wrap(~ Relation_to_UCSC_CpG_Island) creates a volcano plot per each of the categories found in Relation_to_UCSC_CpG_Island column
# labs(title = "Volcano Plots - Age") adds the main title
ggplot(results_age[adj.P.Val < 1e-5]) + 
  aes(logFC,-log10(P.Value)) + 
  geom_point(aes(color = Relation_to_UCSC_CpG_Island),size=1) + 
  theme_bw() +
  facet_wrap(~ Relation_to_UCSC_CpG_Island) + 
  labs(title = "Volcano Plots - Age")

#same logic but for results_biological_sex volcano plots
ggplot(results_biological_sex[adj.P.Val < 1e-5]) + 
  aes(logFC,-log10(P.Value)) + 
  geom_point(aes(color = Relation_to_UCSC_CpG_Island),size=1) + 
  theme_bw() +
  facet_wrap(~ Relation_to_UCSC_CpG_Island) + 
  labs(title = "Volcano Plots - Biological Sex") 
