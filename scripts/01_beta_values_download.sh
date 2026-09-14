#set proper directory

cd ./GSE40279/files/GSE/


#to get betas (methylation values)

wget "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE40279&format=file&file=GSE40279%5Faverage%5Fbeta%2Etxt%2Egz" 



#to check out betas without unzipping the file

zcat "index.html?acc=GSE40279&format=file&file=GSE40279_average_beta.txt.gz" | head -50 
#sample nomenclature: CpG names as cg(n) and sample name as X(n)