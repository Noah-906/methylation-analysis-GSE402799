#change to proper directory

cd ./GSE40279/files/GPL/



#how to get the file

wget -O GPL13534_full_table.txt "https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GPL13534&targ=self&view=data&form=text" 



#check row number

wc -l GPL13534_full_table.txt 
#result -> 485618



#check how many CpGs there are

grep -c "^cg" GPL13534_full_table.txt
#result -> 482421



#check how many rs there are

grep -c "^rs" GPL13534_full_table.txt
#result -> 65



#check how many ch there are

grep -c "^ch" GPL13534_full_table.txt
#result -> 3091



#check header

sed -n '1,40p' GPL13534_full_table.txt



#check where the header begins

head -40 GPL13534_full_table.txt
#the first line containing the name of the columns



#where the first actual row of data is
head -41 GPL13534_full_table.txt 
