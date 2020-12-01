# Katja Seltmann, 2020
# Script to map occurrence records of species (lat/long) that occur only within the boundaries of Coal Oil Point Reserve (shp file)
# COPR occurrence records in tab-delimited format: https://ucsb.box.com/s/7xp88xhg1xn7decsv0t3ll8du653deub
# COPR boundary files: https://ucsb.box.com/s/nd1s0e3ted8zsu0ir4wbxu7qpe94ht8o

#TODO:
#draw boundary of copr on map
#Trim specimen_data based on copr boundary creating new file that only contains specimens whose coordinates are within that boundary

setwd("~/Box Sync/CCBER_Projects/Symbiota_UCSB_Data_Portal")

#required libraries
library(ggplot2)
library(maptools)
library(sf)
library(maps)


#file that contains over 75K of specimen data with lat/long coordinates
specimen_data <- read.delim(file="COPR/0122511-200613084148143/occurrence.txt",header=TRUE)

#print data dimensions
dim(specimen_data)

#remove rows where lat/long do not exist
specimen_data <- subset(specimen_data, !is.na(order) & !is.na(decimalLongitude) & !is.na(decimalLatitude))

#print data dimensions
dim(specimen_data)

#remove columns and rows for smaller test dataset that only includes long and lat, and limit to only 100 rows for testing
#column decimalLongitude = 134
#column decimalLatitude = 133
specimen_data_less <-specimen_data[1:100,c(134,133)]
head(specimen_data_less)

#print dimensions of new dataset
dim(specimen_data_less)

#read boundary from shp file
copr_boundary_2020 <- st_read("COPR/COPR_Boundary_2010/COPR_boundary2010.shp")

#graph boundary and points
ggplot(data = copr_boundary_2020) + 
  geom_point(data = specimen_data_less, aes(x = decimalLongitude, y = decimalLatitude), shape = 1)




     

  




  



