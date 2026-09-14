#change to appropriate directory
cd ./GSE40279/files/GSE/supplement_age_phenotype/ 

#url of website
wget "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE40nnn/GSE40279/matrix/"

#url corrected from the downloaded html 
wget "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE40nnn/GSE40279/matrix/GSE40279_series_matrix.txt.gz" 

#check out the str
zcat "GSE40279_series_matrix.txt.gz" | head -50
#age result: !Sample_title	"age 67y 1001"	"age 89y 1002" 

#unzip the file keeping also the original
gunzip -k GSE40279_series_matrix.txt.gz 

#find the row beginning with !Sample_title and print it into age.txt
grep '^!Sample_title' "./GSE40279/files/GSE/supplement_age_phenotype/GSE40279_series_matrix.txt" > age.txt

#check the type of separator
head -c 100 age.txt 
