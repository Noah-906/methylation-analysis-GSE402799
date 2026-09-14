# grep --> searches for patterns within text files
# -i --> case-insensitive option (matches "gender", "Gender", "GENDER", etc.)
# "gender" --> search pattern
# GSE40279_series_matrix.txt --> target file (a GEO metadata text file)
# grep -i "gender" ... --> searches for any line containing the word "gender" (ignoring uppercase/lowercase) in the matrix file and prints it to the terminal
grep -i "gender" ./GSE40279/files/GSE/supplement_biological_sex_phenotype/GSE40279_series_matrix.txt

# grep --> searches for patterns within text files
# "^!" --> regular expression matching lines that start with "!" (GEO header/metadata lines)
# | (pipe) --> passes the output of the grep command as input to the next command
# cut -f1-5 --> extracts only the first 5 tab-separated fields (columns) per line
# grep "^!" ... | cut -f1-5 --> filters for metadata lines and prints only their first 5 columns to the terminal for a quick preview
grep "^!" ./GSE40279/files/GSE/supplement_biological_sex_phenotype/GSE40279_series_matrix.txt | cut -f1-5

# wc -l --> counts and prints the total number of lines in the file
wc -l ./GSE40279/files/GSE/supplement_biological_sex_phenotype/GSE40279_series_matrix.txt

# grep gender ... > biological_sex_info.tsv --> searches for lines containing "gender" and redirects (> ) the output into a new file
grep gender ./GSE40279/files/GSE/supplement_biological_sex_phenotype/GSE40279_series_matrix.txt > biological_sex_info.tsv

# grep ethnicity ... > ethnicity_info.tsv --> searches for lines containing "ethnicity" and redirects (> ) the output into a new file 
grep ethnicity ./GSE40279/files/GSE/supplement_biological_sex_phenotype/GSE40279_series_matrix.txt > ethnicity_info.tsv

