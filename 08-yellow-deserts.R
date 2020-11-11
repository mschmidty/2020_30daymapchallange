library(rnaturalearth)
library(stars)
library(tidyverse)
library(schmidtytheme)
library(raster)
library(sf)

theme_set(theme_schmidt())

veg<-read_stars("data/large_files/US_140EVT_2018/Grid/us_140evt.ovr")

veg2<-raster("data/large_files/US_140EVT_2018/Grid/us_140evt.ovr")


poly<-st_read("data/large_files/US_140EVT_2018/Spatial_Metadata/US_140_SPATPLYGN.shp")

meta<-read_csv("data/large_files/US_140EVT_2018/CSV_Data/LF_140EVT_09152016.csv")

meta





plot(veg2)


