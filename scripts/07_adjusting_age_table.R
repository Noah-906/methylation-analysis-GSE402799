#load libraries
library(tidyverse)
library(data.table)
library(stringr)

#set proper directory
setwd("./GSE40279/output/phenotype_data")

#readLines --> load age.txt in a single vector chr (the file has 1 line)
#strsplit(line, "\t") --> split the line vector chr everytime it meets \t
#[[1]] extracts the first element of the list (that is "!Sample_title") and [-1] removes it
#all is saved into values, containing all 656 samples
line <- readLines("age.txt")
values <- strsplit(line, "\t")[[1]][-1] 

#age <- tibble(raw = values) %>% --> takes values and inserts it into a tibble table which has one column called raw
#extract() --> scans the file, looks for patterns and extracts them to make new columns
#col = raw --> select column to analyse
#into = c("age", "ID") --> creates two separated columns that will be called "age" and "ID"
#regex = ".*age (\\d+)y (\\d+)\"" --> looks for the word age and captures the number before y, then captures the second number..
#...the () identifies where the txt of interest is found
#convert = TRUE --> if the extracted values are numbers, treat them as numeric variables
#paste0("X", ID) --> paste0 adds an X in front of the numbers (the X was not present in the original file)
#mutate(ID = ...) --> uploads the ID column of the tibble table with the one created by paste0
#as.data.table() --> transforms the file into a data.table 
age <- tibble(raw = values) %>%  
  extract(
    col = raw, 
    into = c("age", "ID"), 
    regex = ".*age (\\d+)y (\\d+)\"", 
    convert = TRUE
  ) %>% 
  mutate(ID = paste0("X", ID)) %>% 
  as.data.table() # <- Trasforma il risultato finale in data.table

#saveRDS(age, file = "age_table.rds") 
