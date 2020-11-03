library(sf)
library(tidyverse)
library(schmidtytheme)


theme_set(theme_schmidt())


dolores<-st_read("data/dolores_lines/NHDFlowline.shp")

dolores%>%
  filter(FType%in% c(460, 558))%>%
  head(10000)%>%
  mutate(size=case_when(
    FCode==46006 ~ 2,
    TRUE~1
  ))%>%
  ggplot()+
  geom_sf(aes(size=Visibility, color=Visibility))+
  coord_sf()+
  scale_size_continuous(range = c(0.2, 1))+
  scale_color_continuous("#7c7c7d", "#1e567d")+
  theme(
    plot.background=element_rect(fill="#222222"),
    panel.background=element_rect(fill="#222222"),
    panel.grid.major=element_line(color="transparent"),
    legend.position = "none"
  )


dolores%>%
  as_tibble()%>%
  View()
