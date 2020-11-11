library(tidyverse)
library(sf)

trails<-st_read("data/colorado_trails/Trails_COTREX10212020.shp")


trails%>%
  as_tibble()%>%
  select(-geometry)%>%
  View()
