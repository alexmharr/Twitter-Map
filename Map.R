library(twitteR)
library(dplyr)
library(maps)
library(stringr)
library(ggplot2)
library(mapproj)
library(maptools)
library(ggvis)
library(rgdal)


state <- map_data("state")
View(state)
sh <- readOGR("citiesx010g_shp_nt00962 (1)/citiesx010g.shp", layer = "citiesx010g" ,stringsAsFactors = FALSE)
View(sh)
ggplot(data = sh) +
  geom_polygon(mapping = aes(x = LONGITUDE, y = LATITUDE, group = GNIS_ID))

trends <- availableTrendLocations()

state %>%
  ggvis(~long, ~lat) %>%
  group_by(group) %>%
  layer_paths(strokeOpacity:=0.5, stroke:="#7f7f7f") %>%
  hide_legend("fill") %>%
  hide_axis("x") %>% hide_axis("y") %>%
  set_options(width=400, height=600, keep_aspect=TRUE)






cities <- cities %>% select(name, lat, long)
cities$name <- substr(cities$name,1, nchar(cities$name) - 3) 
try <- merge(cities, us.woeids, all = TRUE)
try <- try[complete.cases(try), ]
rownames(try) <- NULL