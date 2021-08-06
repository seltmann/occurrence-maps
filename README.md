## occurrence-maps

[```Citation```](#Citation) / [```Filter Polygon```](#filter-polygon)

### Description
This GitHub repository for scripts that map occurrence records, either from observations or natural history collections.


### Citation
Started by Katja Seltmann, 2021 (add your names here)

### Filter Polygon

Script to map occurrence records of species (lat/long) that occur only within the boundaries of Coal Oil Point Reserve (shp file)

*requirements*

The test occurrence records from Coal Oil Point Researve and COPR boundry file are also available on Box. 

COPR test occurrence records: https://ucsb.box.com/s/7xp88xhg1xn7decsv0t3ll8du653deub

COPR boundary files: https://ucsb.box.com/s/nd1s0e3ted8zsu0ir4wbxu7qpe94ht8o

### Metadata
COPR boundary data CRS is in NAD83 California Zone 5 (ESPG:2229)
COPR occurence record data CRS is in WGS84 (ESPG:4326)
COPR occurrence record data transformation from WGS84 to NAD83 causes ~1m of error. Citation: https://epsg.org/transformation_1750/NAD83-to-WGS-84-54.html?sessionkey=npd9npmm3p
for more information please refer to the data carpentry lesson on Coordinate Reference Systems: https://datacarpentry.org/organization-geospatial/03-crs/index.html 
