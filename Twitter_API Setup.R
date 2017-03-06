
library(streamR)
library(RCurl)
library(RJSONIO)
library(stringr)
#the code below is used to connect the twitter api
library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "APMnFSmvPJ56HLqRlO957IpNa"
consumerSecret <- "6Ra0pjhVcqQl64ArBrQtY6jUCraqJYrLA9bTs9MmFv7no3V8Zp"

my_oauth <- OAuthFactory$new(consumerKey = consumerKey,
                             consumerSecret = consumerSecret,
                             requestURL = requestURL,
                             accessURL = accessURL,
                             authURL = authURL)

my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
save(my_oauth, file = "my_oauth.Rdata")

tweets_geolocated <- searchTwitter("#", n=100, lang="en", geocode='34.04993,-118.24084,50mi', since="2014-08-20")
tweets_geoolocated.df <- twListToDF(tweets_geolocated)
#use to collect tweets base on location
load("my_oauth.Rdata")
filterStream(file.name = "tweets.json", # Save tweets in a json file
             track = c("#"), # Collect tweets mentioning either Affordable Care Act, ACA, or Obamacare
             language = "en",
             location  = c(-119, 33, -117, 35),
             timeout = 60, 
             oauth = my_oauth) # Use my_oauth file as the OAuth credentials

tweets.df <- parseTweets("tweets.json", simplify = FALSE)
#extract only the hashtags
textScrubber <- function(dataframe) {
  dataframe$text <-  str_extract(dataframe$text,"#\\S+")
  return(dataframe)
}
View(tweets.df)

tweets.df <- textScrubber(tweets.df)

