library(rnaturalearth)
library(tidyverse)
library(schmidtytheme)
library(sf)
library(raster)
library(foreign)
library(elevatr)
library(osmdata)
library(patchwork)
library(extrafont)
loadfonts()

theme_set(theme_schmidt()+theme(
  plot.background=element_rect(color="transparent", fill="#FFFFFF"),
  panel.background=element_rect(fill="#FFFFFF", color="transparent"),
  plot.title=element_text(family="Public Sans Light", color="#A2A2A2"), 
))

evt<-raster("data/large_files/Dolores_UTM_US_200EVT/US_200EVT\\US_200EVT.tif")

meta<-read.dbf("data/large_files/Dolores_UTM_US_200EVT/US_200EVT\\US_200EVT.tif.vat.dbf")%>%
  as_tibble()

barn<-tibble(
  place = c("Dolores"),
  lat = c(37.441623),
  lon = c(-108.520953)
)%>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326)%>%
  st_transform(26912)

hood<-barn%>%
  st_buffer(10000)

evt_crop<-evt%>%
  crop(as(hood, "Spatial"))%>%
  mask(as(hood,"Spatial"))

evt_crop_pts<-evt_crop%>%
  rasterToPoints()%>%
  as_tibble()%>%
  rename(Value=3)%>%
  drop_na(Value)%>%
  left_join(dplyr::select(meta, Value, EVT_Name, EVT_PHYS), by="Value")

grouped_pts<-evt_crop_pts%>%
  mutate(veg_cat=case_when(
    str_detect(EVT_PHYS, "Conifer|Hardwood|Tree") ~ "Forest",
    str_detect(EVT_PHYS, "Shrubland|Sparse|Grass") ~ "Shrubland/Grassland",
    EVT_PHYS=="Agricultural" ~ "Agricultural",
    TRUE~"Other"
  ))

dem<-get_elev_raster(evt_crop, z=12, prj="+proj=utm +zone=12 +datum=NAD83 +units=m +no_defs")

dem_crop<-dem%>%
  crop(as(hood, "Spatial"))%>%
  mask(as(hood,"Spatial"))

slope<-terrain(dem_crop, opt="slope")
aspect<-terrain(dem_crop, opt="aspect")

hill<-hillShade(slope, aspect, 5, 270)%>%
  rasterToPoints()%>%
  as_tibble()
  

q2<-opq(bbox=st_bbox(hood%>%
                       st_transform(4326)))%>%
  add_osm_feature("natural", "water")


reservoir_sf<-osmdata_sf(q2)$osm_multipolygons%>%
  st_transform("+proj=utm +zone=12 +datum=NAD83 +units=m +no_defs")

reservoir<-reservoir_sf%>%
  st_intersection(hood)


forest<-ggplot()+
  geom_raster(data=filter(grouped_pts, veg_cat=="Forest"), aes(x=x, y=y), fill="#57A965")+
  geom_sf(data=reservoir, color="transparent", fill="#4C5A78")+
  geom_raster(data=hill, aes(x=x, y=y, fill=layer), alpha = 0.5)+
  scale_fill_gradient(low="#ffffff", high="#000000")+
  coord_sf()+
  labs(
    title="FOREST",
    x="",
    y=""
  )+
  theme(
    panel.grid.major=element_blank(),
    axis.text = element_blank(),
    legend.position="none"
  )

grass<-ggplot()+
  geom_raster(data=filter(grouped_pts, str_detect(veg_cat, "Grass")), aes(x=x, y=y), fill="#FFC200")+
  geom_sf(data=reservoir, color="transparent", fill="#4C5A78")+
  geom_raster(data=hill, aes(x=x, y=y, fill=layer), alpha = 0.5)+
  scale_fill_gradient(low="#ffffff", high="#000000")+
  coord_sf()+
  labs(
    title="SHRUBS & GRASS",
    x="",
    y=""
  )+
  theme(
    panel.grid.major=element_blank(),
    axis.text = element_blank(),
    legend.position="none"
  )

ag<-ggplot()+
  geom_raster(data=filter(grouped_pts, str_detect(veg_cat, "Agricul")), aes(x=x, y=y), fill="#8A6E6E")+
  geom_sf(data=reservoir, color="transparent", fill="#4C5A78")+
  geom_raster(data=hill, aes(x=x, y=y, fill=layer), alpha = 0.5)+
  scale_fill_gradient(low="#ffffff", high="#000000")+
  coord_sf()+
  labs(
    title="AGRICULTURE",
    x="",
    y=""
  )+
  theme(
    panel.grid.major=element_blank(),
    axis.text = element_blank(),
    legend.position="none"
  )


forest+grass+ag+
  ggsave("output/13-raster-vegetation-around-my-home.png", type="cairo")
  


