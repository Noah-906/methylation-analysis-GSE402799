# loading libray
library(data.table)

# set working directory
setwd("./GSE40279/output/phenotype_data/")

# loading files
age_table <- readRDS("./GSE40279/output/phenotype_data/age_table.rds")
biological_sex <- fread("./GSE40279/output/phenotype_data/biological_sex_info.tsv", header = FALSE)
ethnicity <- fread("./GSE40279/output/phenotype_data/ethnicity_info.tsv", header = FALSE)

# biological_sex[, -1, with = FALSE] --> drops the 1st column (e.g., ID) and keeps the remaining columns as a data.table
# unlist(..., use.names = FALSE) --> flattens the resulting data.table into a plain R vector without keeping row/column names
# biological_sex_vector <- ... --> stores the extracted values in a vector named 'biological_sex_vector'
biological_sex_vector <- unlist(biological_sex[, -1, with = FALSE], use.names = FALSE)

# same logic but for ethnicity
ethnicity_vector <- unlist(ethnicity[, -1, with = FALSE], use.names = FALSE)

# # sub(pattern, replacement, x) --> replaces the first occurrence of a pattern in a character vector
# "gender: " --> target substring (prefix) to search for
# "" --> replacement string (empty string to delete the target)
# biological_sex_vector <- ... --> overwrites 'biological_sex_vector' with the cleaned values (without "gender: ")
biological_sex_vector <- sub("gender: ", "", biological_sex_vector)

# same logic but for ethnicity
ethnicity_vector <- sub("ethnicity: ", "", ethnicity_vector) 

# sub(".*-\\s*", "", x) --> regular expression: '.*' matches any character up to the hyphen '-', and '\\s*' matches optional trailing whitespace
# sub(...) --> deletes everything from the beginning of the string up to the hyphen (and any space right after it)
# trimws(...) --> removes any remaining leading or trailing whitespace from the resulting strings
# ethnicity_clean <- ... --> stores the fully cleaned strings into a new vector named 'ethnicity_clean'
ethnicity_clean <- trimws(sub(".*-\\s*", "", ethnicity_vector))

# copy() --> creates a deep copy of 'age_table' to avoid modifying the original data.table by reference
age_table_merged <- copy(age_table)

# age_table_merged[...] --> selects the target data.table
# biological_sex --> name of the new column to add
# := adds the column in-place 
# biological_sex_vector --> vector containing the values to insert into the new biological_sex column
# age_table_merged[, biological_sex := biological_sex_vector] --> assigns the vector values directly to the biological_sex column
age_table_merged[, biological_sex := biological_sex_vector]

# same logic but for ethnicity
age_table_merged[, ethnicity := ethnicity_vector] 

# names(age_table_merged) --> retrieves a character vector with all column names of the data.table
# c("ID", "age") --> defines the desired starting columns
# setdiff(names(...), c("ID", "age")) --> finds the remaining column names by removing "ID" and "age" from the list
# setcolorder(dt, neworder) --> reorders the columns of the data.table in-place (without making a copy in memory)
# setcolorder(...) --> places "ID" and "age" as the first two columns, followed by all remaining columns
setcolorder(age_table_merged, c("ID", "age", setdiff(names(age_table_merged), c("ID", "age"))))

# age_table_merged$ID / age_table$ID --> extracts the 'ID' vector from both data.tables
# identical(...) --> compares both vectors element-by-element to ensure row order remained unchanged
identical(age_table_merged$ID, age_table$ID) # should return TRUE 
# [1] TRUE

# assigns the reordered data.table to its final object name phenotype_table
phenotype_table <- age_table_merged 

# rm() --> removes age_table_merged from the R environment 
rm(age_table_merged)

# save file
saveRDS(phenotype_table, file = "phenotype_table.rds") 
