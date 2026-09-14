#load required libraries
library(data.table)
library(ggplot2)

#load the file (already unzipped)
beta_values <- fread("./GSE40279/files/GSE/GSE40279_average_beta.txt")

#check structures beta_values
str(beta_values)


#PLOTTING BETA VALUES

#boxplot wiht all the rows of beta values but the first column
#xaxt = "n" --> no label on x-axis, it would be too messy
boxplot(beta_values[, -1, with = FALSE], main = "Beta value distribution", ylab = "Beta value", xaxt = "n")

#For reproducibility
set.seed(123)

#c(1...) --> combine the first column (ID_REF) with all the remaining ones
#ncol(beta_values) --> give back all the columns of my dataset starting from the second one
#size = 100 --> specifies how many random samples i consider
#sample() --> takes randomly 100 samples from the 656
selected_columns <- c(1, sample(2:ncol(beta_values), size = 100))

#from beta values, extract only the selected columns keeping all the rows
#with = FALSE is a condition of data.table
beta_sub <- beta_values[, selected_columns, with = FALSE]

#unlist --> takes all the beta values from beta_sub, making a list
#the -1 is because the first column is not considered
sampled_beta <- unlist(beta_sub[, -1, with = FALSE])

#!is.na(sampled_beta) --> keep everything that IS NOT na
sampled_beta <- sampled_beta[!is.na(sampled_beta)]

#plot betas density distribution 
plot(density(sampled_beta), 
     main = "Density Plot of Methylation Beta Values (100 Samples, All CpGs)", #title
     xlab = "Beta value", #x-axis value
     ylab = "Density", #y-axis value
     col = "darkblue",  #line color
     lwd = 2) #default line thickness

#remove files that are not needed anymore (optional)
rm(sampled_beta, beta_sub)
gc() 



