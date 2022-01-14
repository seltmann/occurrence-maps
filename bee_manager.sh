
########################
#Author: JT Miller
#Email: jtmiller@ucsb.edu
#Date: January 2022
#Purpose: To filter down data to only include pertinent info (for occurrence data) from GBIF #search on bees
#Data https://doi.org/10.15468/dl.4qr9s2 
#Run in command line as: bee_manager.sh
#########################
#Parts
#1)Upload data from GBIF and call it usa_bees.txt, the cut command then brings in columns 133,134 which are decimal latitude and longitude. 191-198 include taxonomic rank. 

echo cut important columns
cat occurrence.txt |cut -f 133,134,191,192,193,194,195,196,197,198 > bee_occurrence2.txt