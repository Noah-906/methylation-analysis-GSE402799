#set working directory
setwd("./GSE40279/output/")

#load the file (already unzipped)
beta_values <- fread("./GSE40279/files/GSE/GSE40279_average_beta.txt")
manifest <- fread("./GSE40279/files/GPL/GPL13534-11288.txt") 

#beta_values[...] --> data.table synthax for data analysis
#substr(ID_REF, 1, 2) --> considering ID_REF column, extracts the first two letters of the chr and makes a substring
#Prefix is the name of this temporary groups' column
#.() = list() abbreviation --> used to wrap columns to evaluate them
#.N --> count how many rows each group has, this number appears in the column named "count"
beta_values[, .(Count = .N), by = .(Prefix = substr(ID_REF, 1, 2))]
#  Prefix  Count
#   <char>  <int>
#1:     cg 470043
#2:     ch   2991

#grepl("^ch", ID_REF) --> grepl() looks into ID_REF column and yields TRUE everytime the chr starts with ch
#! --> TRUE values become FALSE and vice versa
#beta_values_clean contains ONLY rows whose chr DO NOT START with "ch"
beta_values_clean <- beta_values[!grepl("^ch", ID_REF)]

beta_values_clean[, .(Count = .N), by = .(Prefix = substr(ID_REF, 1, 2))] 
# Prefix  Count
#   <char>  <int>
#1:     cg 470043 


#CHR %in% c("X", "Y") --> search in CHR column the "X" and "Y" chr
# , ID --> of these X and Y rows, it selects only the ID of CpGs
#these CpGs' ID are saved into sex_chr_probes
sex_chr_probes <- manifest[CHR %in% c("X", "Y"), ID]

#check for NA values
any(is.na(sex_chr_probes))
#FALSE

#ID_REF %in% sex_chr_probes --> check if in the ID_REF of beta_values_clean, there are probes whose ID belongs to sex_chr_probes
#! --> takes everything that is NOT in sex_chr_probes 
beta_values_autosomal <- beta_values_clean[!ID_REF %in% sex_chr_probes]

#the beta_values_autosomal contains the very same probes of beta_values_clean
#this means that the methylation beta_values were already without the sex_chr_probes 

saveRDS(beta_values_autosomal, file = "beta_values_autosomal.rds") 
