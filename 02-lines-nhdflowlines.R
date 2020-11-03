library(sf)
library(tidyverse)
library(schmidtytheme)
extrafont::loadfonts()


theme_set(theme_schmidt())


dolores<-st_read("data/dolores_lines/NHDFlowline.shp")

dolores_single<-dolores%>%
  filter(GNIS_Name == "Dolores River")

dolores_sub<-dolores%>%
  filter(FType%in% c(460, 558) & Visibility!=0)%>%
  mutate(size=case_when(
    FCode==46006 ~ 2,
    TRUE~1
  ))

ggplot()+
  geom_sf(data=dolores_sub, aes(size=Visibility, color=Visibility))+
  geom_sf(data=dolores_single, size=0.75, color="#7d96b5")+
  coord_sf()+
  scale_size_continuous(range = c(0.1, 0.45))+
  scale_color_continuous(low="#aaaaaa", high = "#d4c6a7")+
  theme(
    plot.title = element_text(family = "Lato", color="#FFFFFF"),
    axis.text = element_text(family = "Lato", color="#6e6e6e", size=7),
    plot.background=element_rect(fill="#222222"),
    panel.background=element_rect(fill="#222222", color="transparent"),
    panel.grid.major=element_line(color="#404040", size=0.2),
    legend.position = "none"
  )+
  ggsave("output/02-lines-Dolores-River-watershed_big.png",h=11, w=11, type="cairo")

