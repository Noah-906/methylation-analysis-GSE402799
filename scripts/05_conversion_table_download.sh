#change to appropriate directory

cd ./GSE40279/files/GSE/



#link to conversion table

wget "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE40279&format=file&file=GSE40279%5Fsample%5Fkey%2Etxt%2Egz"



#check structure

zcat "index.html?acc=GSE40279&format=file&file=GSE40279_sample_key.txt.gz" | head -50
#results: 
#1001	5815284001_R01C01
#1002	5815284001_R02C01
#1003	5815284001_R03C01

