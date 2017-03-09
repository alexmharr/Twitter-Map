library(dplyr)
library(twitteR)
library(ggmap)
library(data.table)
library(ggplot2)
library(ggvis)
library(rgdal)
library(mapproj)
library(leaflet)

source("Google API.R")
setup_twitter_oauth(a, b, c, d)

UW <- getUser("UW")
UW.followers <- UW$getFollowers(retryOnRateLimit = 180)
UW.df <- rbindlist(lapply(UW.followers,as.data.frame))
UW.df.loc <- UW.df %>% select(name, screenName, location) %>% 
  filter(location != "")

View(UW.df.loc)

write.csv(UW.df, "UW_Followers")
View(UW.df)


length(UW.followers)

length(UW.followers)

UW.IDs.df <- twListToDF(UW.followers)

View(UW.IDs.df)

ah.follower <- twListToDF(ah.follower.IDs)

ah.follower <- subset(ah.follower, location != "")
ah.follower$location <- gsub("%", " ", ah.follower$location)

UW <- getUser("UW")
UW.followers <- UW$getFollowers(retryOnRateLimit = 180)

UW.df <- rbindlist(lapply(UW.followers,as.data.frame))

UW.df.loc <- UW.df %>% select(name, screenName, location) %>% 
  filter(location != "")
UW.df.loc$location <- gsub("%", " ", UW.df.loc$location)

#Install key package helpers:
source("https://raw.githubusercontent.com/LucasPuente/geocoding/master/geocode_helpers.R")
#Install modified version of the geocode function
#(that now includes the api_key parameter):
source("https://raw.githubusercontent.com/LucasPuente/geocoding/master/modified_geocode.R")

geocode_apply <-function(x){
  geocode(x, source = "google", output = "all", api_key="AIzaSyBNrv5C3SAZ9NDIHkLwnPTjvQzslWp0kpQ")
}

geocode_results <- sapply(UW.df.loc$location, geocode_apply, simplify = F)


#condition_a <- geocode_results %>% 
  #filter(status == "OK")

#condition_b

condition_a <- sapply(geocode_results, function(x) x["status"] == "OK")
geocode_results <- geocode_results[condition_a]
condition_b <- lapply(geocode_results, lapply, length)
condition_b2 <- sapply(condition_b, function(x) x["results"]=="1")
geocode_results <- geocode_results[condition_b2]
length(geocode_results)

for(i in 1:length(geocode_results)){
  dynamic_j<-length(geocode_results[[i]]$results[[1]]$address_components)
  for(j in 1:dynamic_j){
    if(length(geocode_results[[i]]$results[[1]]$address_components[[j]]$types)>2){
      geocode_results[[i]]$results[[1]]$address_components[[j]]$types<-geocode_results[[i]]$results[[1]]$address_components[[j]]$types[(length(geocode_results[[i]]$results[[1]]$address_components[[j]]$types)-1):length(geocode_results[[i]]$results[[1]]$address_components[[j]]$types)]
    }
  }
  if(length(geocode_results[[i]]$results[[1]]$types)>2){
    geocode_results[[i]]$results[[1]]$types<-geocode_results[[i]]$results[[1]]$types[(length(geocode_results[[i]]$results[[1]]$types)-1):length(geocode_results[[i]]$results[[1]]$types)]
  }
  if(length(geocode_results[[i]]$results[[1]]$types)<1){
    geocode_results[[i]]$results[[1]]$types<-"Unknown"
  }
  dynamic_k<-length(geocode_results[[i]]$results[[1]]$address_components)
  for(k in 1:dynamic_k){
    if(length(geocode_results[[i]]$results[[1]]$address_components[[k]]$types)<1){
      geocode_results[[i]]$results[[1]]$address_components[[k]]$types<-"Unknown"
    }
  }
  if(length(geocode_results[[i]]$results[[1]]$postcode_localities)>2){
    geocode_results[[i]]$results[[1]]$postcode_localities<-geocode_results[[i]]$results[[1]]$postcode_localities[(length(geocode_results[[i]]$results[[1]]$postcode_localities)-1):length(geocode_results[[i]]$results[[1]]$postcode_localities)]
  }
}

results <- lapply(geocode_results, as.data.frame)

results_c<-lapply(results,function(x) subset(x, select=c("results.formatted_address",
                                                           "results.geometry.location")))

results_d<-lapply(results_c,function(x) data.frame(Location=x[1,"results.formatted_address"],
                                                   lat=x[1,"results.geometry.location"],
                                                   lng=x[2,"results.geometry.location"]))
source("Google API.R")
google.api
results_e<-rbindlist(results_d)

american_results <-subset(results_e,
                         grepl(", USA", results_e$Location)==TRUE)

american_results1 <- american_results %>% filter(lng >-125)




write.csv(american_results, "american_results")
american_results <- read.csv("Data/american_results", stringsAsFactors = FALSE)




m <- leaflet(data = state) %>% 
  addTiles() %>% 
  addMarkers(-100, 42)

m



state <- map_data("state")
View(state)
state %>%
  ggvis(~long, ~lat) %>%
  group_by(group) %>%
  layer_paths(strokeOpacity:=1, stroke:="#7f7f7f", fill = ~group) %>%
  layer_points(data = american_results1, x = ~lng, y = ~lat, size = .8) %>% 
  hide_legend("fill") %>% 
  #hide_axis("x") %>% hide_axis("y") %>%
  set_options(width=600, height=600, keep_aspect=TRUE)









