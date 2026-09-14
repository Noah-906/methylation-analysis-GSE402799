#load proper library
library(data.table)

#load the manifest
manifest <- fread("./GSE40279/files/GPL/GPL13534-11288.txt")

#i noticed that the manifest has 485577 rows instead of 485615 (38 rows less)

#manifest[...] --> data.table structure for data analysis
#substr(ID, 1, 2) --> considering ID column, extracts the first two letters of the chr and makes a substring
#Prefix is the name of this temporary groups' column
#.() = list() abbreviation --> used to wrap columns to evaluate them
#.N --> count how many rows each group has, this number appears in the column named "count"
manifest[, .(Count = .N), by = .(Prefix = substr(ID, 1, 2))]
# Prefix  Count
#   <char>  <int>
#1:     cg 482421
#2:     ch   3091
#3:     rs     65 

#check the header
head(manifest)[1:5]
#the 38 rows removed are the header, so the file it's ready for further analysis 
