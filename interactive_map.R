library(dplyr)
library(data.table)
library(ggplot2)
library(ggvis)
library(rgdal)
library(mapproj)
library(leaflet)
library(twitteR)
library(ggmap)
library(htmltools)

setup_twitter_oauth("APMnFSmvPJ56HLqRlO957IpNa", "6Ra0pjhVcqQl64ArBrQtY6jUCraqJYrLA9bTs9MmFv7no3V8Zp", 
                    "2340813607-fJqGczp5N7NhyrcGfoMR8Hx0yEc3UhOO5x4eJOh", "x7Ty5DTPxnBnMcXcwy3KP2vX4inB3UnNqsk0h6bjtzJoO")

state <- map("state", fill = TRUE, plot = FALSE)
american_results <- read.csv("Data/american_results", stringsAsFactors = FALSE)
american_results <- american_results %>% filter(lng >-125)

uw.followers <- read.csv("Data/UW_Followers", stringsAsFactors = FALSE)

names <- uw.followers %>% select(screenName, friendsCount) %>% 
  sample_n(nrow(american_results))

row.names(names) <- NULL

american_results$screenName <- names$screenName
american_results$friends <- names$friendsCount
write.csv(american_results, "american_results")


getColor <- function(df) {
  sapply(df$friends, function(friends) {
    if(friends <= 100) {
      "red"
    } else if(friends > 100 & friends <= 500) {
      "orange"
    } else if(friends > 500 & friends <= 1000) {
      "yellow"
    } else if(friends > 1000 & friends <= 2000) {
      "blue"
    } else if(friends > 2000) {
      "green"
    } else {
      "red"
    } })
}

getRadius <- function(df) {
  sapply(df$friends, function(friends) {
    if(friends <= 100) {
      2
    } else if(friends > 100 & friends <= 500) {
      3
    } else if(friends > 500 & friends <= 1000) {
      5
    } else if(friends > 1000 & friends <= 2000) {
      6
    } else if(friends > 2000) {
      7
    } else {
      8
    } })
}



icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(american_results)
)

binPal <- colorQuantile("Blues", american_results$friends, n = 7)


?labelOptions
leaflet() %>%
  addTiles() %>% 
  addProviderTiles(providers$Esri.WorldStreetMap) %>% 
  setView(lng = -98.35, lat = 39.5, zoom = 3) %>% 
  #addAwesomeMarkers(data = american_results, lng = ~lng, lat = ~lat, icon = icons)
  addMarkers(data = american_results, lng = ~lng, lat = ~lat, label = ~htmlEscape(screenName))



?setView
?leaflet
