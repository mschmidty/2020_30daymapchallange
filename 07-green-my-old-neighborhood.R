library(osmdata)
library(tidyverse)
library(sf)
library(schmidtytheme)

theme_set(theme_schmidt()+
            theme(
              text=element_text(family="Public Sans Light")
            ))

available_features()
available_tags("highway")



q <- getbb("Salt Lake City") %>%
  opq() %>%
  add_osm_feature("leisure", "park")

parks <- osmdata_sf(q)$osm_polygons%>%
  st_transform("+proj=utm +zone=12 +ellps=GRS80 +datum=NAD83")%>%
  st_intersection(hood)

cemetery

street<-tibble(
  place = c("Salt Lake City"),
  lat = c(40.7487517),
  lon = c(-111.861731)
)%>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326)%>%
  st_transform("+proj=utm +zone=12 +ellps=GRS80 +datum=NAD83")

hood<-street%>%
  st_buffer(1600)

hood_plus<-street%>%
  st_buffer(2000)


q2<- opq("Salt Lake City")%>%
  add_osm_feature("highway", c("residential", "service", "unclassified"))

q3<- getbb("Salt Lake City")%>%
  opq()%>%
  add_osm_feature("highway", c("tertiary",  "secondary"))

q4<- opq("Salt Lake City")%>%
  add_osm_feature("highway", "primary")



residential<-osmdata_sf(q2)$osm_lines%>%
  st_transform("+proj=utm +zone=12 +ellps=GRS80 +datum=NAD83")%>%
  st_intersection(hood)
  
tertiary<-osmdata_sf(q3)$osm_lines%>%
  st_transform("+proj=utm +zone=12 +ellps=GRS80 +datum=NAD83")%>%
  st_intersection(hood)

primary<-osmdata_sf(q4)$osm_lines%>%
  st_transform("+proj=utm +zone=12 +ellps=GRS80 +datum=NAD83")%>%
  st_intersection(hood)

background_color <- "#EAEDD2"

ggplot()+
  geom_sf(data = parks, color = "transparent", fill = "#2D2D2D", alpha = 0.8)+
  geom_sf(data = residential, color = "#2D2D2D", size=0.2)+
  geom_sf(data = tertiary, color = "#019214")+
  geom_sf(data = primary, color = "#019214", size = 0.8)+
  ##geom_sf(data = hood, fill = "transparent", color = "#ffffff", size = 0.5)+
  labs(
    title = "MY NEIGHBORHOOD", 
    subtitle = "Salt Lake City, UT",
    caption = "#30DayMapChallenge | @mschmidty | Source: Open Street Map"
  )+
  coord_sf()+theme(
    plot.title = element_text(family = "Public Sans Thin", size = 45, color = "#2D2D2D", margin=margin(30,0,0,0)),
    plot.subtitle = element_text(family = "Public Sans Regular", margin=margin(15,0,25,0)),
    panel.grid.major = element_line(color="transparent"),
    panel.background = element_rect(fill = background_color, color = "transparent"),
    plot.background = element_rect(fill = background_color, color = "transparent"),
    axis.text = element_blank()
  )

