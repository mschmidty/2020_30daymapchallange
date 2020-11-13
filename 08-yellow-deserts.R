library(rnaturalearth)
library(stars)
library(tidyverse)
library(schmidtytheme)
library(sf)
library(raster)


theme_set(theme_schmidt())

evt<-raster("data/large_files/Colorado_EVT/US_105EVT.tif")

meta<-read_csv("data/large_files/Colorado_EVT/LF_140EVT_09152016.csv")

meta%>%
  count(EVT_PHYS)%>%
  View()

desert_potential<-meta%>%
  filter(EVT_PHYS %in% c("Shrubland", "Conifer", "Grassland"))%>%
  pull(VALUE)

points<-evt%>%
  rasterToPoints()

points<-points%>%
  as_tibble()%>%
  rename(value=3)

points_filtered<-points%>%
  filter(value %in% desert_potential)

point_joined<-points%>%
  left_join(meta, by=c("value"="VALUE"))

