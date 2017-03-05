library(devtools)
install_github("twitteR", username="geoffjentry")
library(twitteR)
library(base64enc)
#api_key
api_key <- "xxxxxxxxxxxx"
#api_secret
api_secret <- "xxxxxxxxxxxxxxx"
#access_token
token <- "xxxxxxxx"
#access_token_secret
token_secret <- "xxxxxxxx"

setup_twitter_oauth(api_key,api_secret,token, token_secret)

search.string <- "#nba"
no.of.tweets <- 100
tweets <- searchTwitter(search.string, n = no.of.tweets, lang = "en")


