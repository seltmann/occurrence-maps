#https://rspatial.org/raster/sdm/2_sdm_occdata.html
#https://datacarpentry.org/r-raster-vector-geospatial/06-vector-open-shapefile-in-r/

setwd("~/Box Sync/CCBER_Projects/Symbiota_UCSB_Data_Portal")

#required libraries
library(ggplot2)
library(sf)

#read boundry from shp file
copr_boundary_2020 <- st_read("COPR/COPR_Boundary_2010/COPR_boundary2010.shp")

#reset with new plot
plot.new()

#graph with boundry
ggplot() + 
  geom_sf(data = copr_boundary_2020, size = 3, color = "black", fill = "cyan1") + 
  ggtitle("COPR Boundary Plot") + 
  coord_sf()





