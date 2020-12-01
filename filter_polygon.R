#https://rspatial.org/raster/sdm/2_sdm_occdata.html
#https://datacarpentry.org/r-raster-vector-geospatial/06-vector-open-shapefile-in-r/
#https://benbestphd.com/landscape-ecology-labs/lab6.html

setwd("~/Box Sync/CCBER_Projects/Symbiota_UCSB_Data_Portal")

#required libraries
library(rgeos)
library(maptools)
library(proj4)
library(rgdal)
library(dplyr)
library(raster)


#plot coordinates
specimen_data <- read.delim(file="COPR/0122511-200613084148143/occurrence.txt",header=TRUE)

head(specimen_data, -1)

#print data dimensions
dim(specimen_data)

#remove rows where lat/long do not exist
specimen_data <- subset(specimen_data, !is.na(order) & !is.na(decimalLongitude) & !is.na(decimalLatitude))

#print data dimensions
dim(specimen_data)

#remove columns and rows for smaller test dataset
specimen_data_less <-specimen_data[1:100,c(1,60,64,99,133,134,194,195,230,183)]

#print dimensions of new dataset
dim(specimen_data_less)

#read boundry from shp file
copr_boundary_2020 <- st_read("COPR/COPR_Boundary_2010/COPR_boundary2010.shp")

#reset with new plot when needed
plot.new()

#graph with boundry
ggplot() + 
  geom_sf(data = copr_boundary_2020, size = 3, color = "black", fill = "cyan1") +
  ggtitle("COPR Boundary Plot") + 
  coord_sf()


#plot a very simple map
plot(wrld_simpl, xlim=c(-125,-109), ylim=c(32,43), axes=TRUE, col="light yellow")

#plot using open street map
mapview(specimen_data_less, xcol = "decimalLongitude", ycol = "decimalLatitude", crs = 4269, grid = TRUE)

ggplot() + 
geom_sf(data = copr_boundary_2020, size = 3, color = "black", fill = "cyan1", clip = TRUE) +
ggtitle("COPR Boundary Plot")

help(geom_sf)

geom_sf(data = specimen_data_less, aes(x = decimalLongitude, y = decimalLatitude,colour=factor(order)), size = 1) +
  
library(maps)
world1 <- sf::st_as_sf(map('world', plot = FALSE, fill = TRUE))
ggplot() + geom_sf(data = world1)


#simple plot
library("rnaturalearth")
library("rnaturalearthdata")

world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

plot.new()

map("world", wrap=c(0,360), resolution=0, ylim=c(-60,60))
map.axes()
shp <- readOGR("COPR/COPR_Boundary_2010/COPR_boundary2010.shp")
plot(shp, add=TRUE, col="blue", border=TRUE)
     
     
ggplot(data = world) +
  geom_sf(data = shp,size = 3, color = "black", fill = "cyan1") +
  geom_point(data = specimen_data, aes(x = decimalLongitude, y = decimalLatitude,colour=factor(order)), size = 1)
  




  



