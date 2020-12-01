# Katja Seltmann, 2020
# Script to map occurrence records of species (lat/long) that occur only within the boundries of Coal Oil Point Reserve (shp file)


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

#remove columns and rows for smaller test dataset and limit to only 100 rows for testing
specimen_data_less <-specimen_data[1:100,c(1,60,64,99,133,134,194,195,230,183)]

#print dimensions of new dataset
dim(specimen_data_less)

#read boundry from shp file
copr_boundary_2020 <- st_read("COPR/COPR_Boundary_2010/COPR_boundary2010.shp")

#reset with new plot when needed
plot.new()

#graph with boundry
ggplot() + 
  geom_sf(data = copr_boundary_2020, size = 3, color = "black", fill = "cyan1") + ggtitle("COPR Boundary Plot") + 
  coord_sf()


ggplot() + 
geom_sf(data = copr_boundary_2020, size = 3, color = "black", fill = "cyan1", clip = TRUE) +
ggtitle("COPR Boundary Plot")

help(geom_sf)

     

  




  



