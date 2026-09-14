# loading libraries
library(ggplot2)
library(data.table)

# set working directory
setwd("./GSE40279/")

# load files
results_age <- readRDS("output/limma_analysis/results_age.rds")
results_biological_sex <- readRDS("output/limma_analysis/results_biological_sex.rds")

# results_age[, Relation_to_UCSC_CpG_Island := ...] --> := modifies in place the Relation_to_UCSC_CpG_Island column of results_age data.table
# factor() transforms the chr string in a categorical variable, in this way R orders the chr strings in the way specified after the comma
# c("","Shelf","Shore","Island") --> establishes the new labels' order keeping their original file names
# c("Open Sea","Shelf","Shore","Island") --> assigns new names to the labels (in this case only the first label name is different)
results_age[,Relation_to_UCSC_CpG_Island := factor(Relation_to_UCSC_CpG_Island,
                                                   c("","Shelf","Shore","Island"),
                                                   c("Open Sea","Shelf","Shore","Island"))]

# same logic but for biological sex results
results_biological_sex[,Relation_to_UCSC_CpG_Island := factor(Relation_to_UCSC_CpG_Island,
                                                              c("","Shelf","Shore","Island"),
                                                              c("Open Sea","Shelf","Shore","Island"))]

# ggplot(results_age) for the basics of the chart
# geom_violin() determines the shape of the chart, that is a violin plot
# aes(Relation_to_UCSC_CpG_Island, t, fill = Relation_to_UCSC_CpG_Island) --> Relation_to_UCSC_CpG_Island is the x-axis variable
# ... t is the y-axis variable and fill paints each violin plot with a different color, based on Relation_to_UCSC_CpG_Island category
# quantiles = 0.5 plots the median in each plot
# quantile.linetype = "solid" plots the median as a solid line
# geom_hline() plots an horizontal line along all the graph
# yintercept = 0 is the horizontal line to plot, it has the cartesian coordinates of Y = 0
# lty = 2 plots the y-intercept as a dashed line
ggplot(results_age) + 
  geom_violin(
    aes(Relation_to_UCSC_CpG_Island, t, fill = Relation_to_UCSC_CpG_Island), 
    quantiles = 0.5, 
    quantile.linetype = "solid") +
  geom_hline(yintercept = 0, lty = 2)

# same logic but for biological sex violin plot
ggplot(results_biological_sex) + 
  geom_violin(
    aes(Relation_to_UCSC_CpG_Island, t, fill = Relation_to_UCSC_CpG_Island),
    quantiles = 0.5,
    quantile.linetype = "solid"
  ) +
  geom_hline(yintercept = 0,lty = 2) +
  coord_cartesian(ylim = c(-10, 10)) 