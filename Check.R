library(twitteR)
library(dplyr)
library(maps)
library(stringr)
library(ggplot2)
library(mapproj)
library(maptools)
library(sp)


data("us.cities")
setup_twitter_oauth("APMnFSmvPJ56HLqRlO957IpNa", "6Ra0pjhVcqQl64ArBrQtY6jUCraqJYrLA9bTs9MmFv7no3V8Zp", 
                    "2340813607-fJqGczp5N7NhyrcGfoMR8Hx0yEc3UhOO5x4eJOh", "x7Ty5DTPxnBnMcXcwy3KP2vX4inB3UnNqsk0h6bjtzJoO")

cities <- us.cities
abbreviation <- us.cities$country.etc
avail.trends <- availableTrendLocations()
View(avail.trends)
us.woeids <- avail.trends %>% filter(country == "United States") %>% 
  filter(name != country)
View(us.woeids)
View(us.cities)


cities <- cities %>% select(name, lat, long)
cities$name <- substr(cities$name,1, nchar(cities$name) - 3) 
try <- merge(cities, us.woeids, all = TRUE)
try <- try[complete.cases(try), ]
rownames(try) <- NULL

state <- map_data("state")
lats <- try$lat
longs <- try$long

check <- state %>% filter(lat == lats, long == longs)


View(check)





only.wo <- try %>% select(woeid)




View(cities.shp)
df <- data.frame(trend = " ")
df <- getTrends(2357536) %>% sample_n(1) %>% select(name)
df <- getTrends(only.wo$woeid) 
View(df)
count  <- 1 
getTrends(2352824)
is.numeric(as.numeric(only.wo[1, ]))
as.numeric(only.wo[1, ])
getTrends(2352824)
only.wo[1, ]
temp <- getTrends(as.numeric(only.wo[1, ])) %>% sample_n(1)

for (i in 1:67) {
  temp <- getTrends(v[i]) %>% sample_n(1) %>% select(name)
  df[i, ] <- temp[i, ]
}
View(df)
