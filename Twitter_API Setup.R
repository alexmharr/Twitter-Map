
library(twitteR)
library(streamR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(ROAuth)
library(dplyr)

#the code below is used to connect the twitter api
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "APMnFSmvPJ56HLqRlO957IpNa"
consumerSecret <- "6Ra0pjhVcqQl64ArBrQtY6jUCraqJYrLA9bTs9MmFv7no3V8Zp"
token <- "2340813607-fJqGczp5N7NhyrcGfoMR8Hx0yEc3UhOO5x4eJOh"
token_secret <- "x7Ty5DTPxnBnMcXcwy3KP2vX4inB3UnNqsk0h6bjtzJoO"


# normal search
setup_twitter_oauth(consumerKey,consumerSecret,token, token_secret)
tweets_geolocated <- searchTwitter("#", lang="en", geocode='34.04993,-118.24084,50mi', since="2017-01-01")
tweets_geoolocated.df <- twListToDF(tweets_geolocated)

#head treads from each region
trend <- availableTrendLocations()
worldwide.trend <- getTrends(1)
big.city.trend <- filter(trend, country == "United States") 
  see <- getTrends(2357024)



