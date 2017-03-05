library(devtools)
install_github("twitteR", username="geoffjentry")
library(twitteR)
library(base64enc)

api_key <- "xxxxx"

api_secret <- "xxxxx"

token <- "xxxxx"

token_secret <- "xxxxx"

setup_twitter_oauth(api_key,api_secret,token, token_secret)

search.string <- "#nba"
no.of.tweets <- 100
tweets <- searchTwitter(search.string, n = no.of.tweets, lang = "en")