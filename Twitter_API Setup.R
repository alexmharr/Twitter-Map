#install.packages("twitteR")
#install.packages("ROAuth")
library(twitteR)
library(ROAuth)
#set working directory to the repo
# Download "cacert.pem" file
download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")

#create an object "cred" that will save the authenticated object that we can use for later sessions
cred <- OAuthFactory$new(consumerKey='APMnFSmvPJ56HLqRlO957IpNa',
                         consumerSecret='6Ra0pjhVcqQl64ArBrQtY6jUCraqJYrLA9bTs9MmFv7no3V8Zp',
                         requestURL='https://api.twitter.com/oauth/request_token',
                         accessURL='https://api.twitter.com/oauth/access_token',
                         authURL='https://api.twitter.com/oauth/authorize')
save(cred, file="twitter authentication.Rdata")
#execute the command below, which will redirect you to another page. Copy the pin from that page, then enter the pin
#into the console where it says enter pin.
cred$handshake(cainfo="cacert.pem")
#run the command below and then in the console, say yes when prompted.
setup_twitter_oauth("APMnFSmvPJ56HLqRlO957IpNa", "6Ra0pjhVcqQl64ArBrQtY6jUCraqJYrLA9bTs9MmFv7no3V8Zp", 
                    "2340813607-fJqGczp5N7NhyrcGfoMR8Hx0yEc3UhOO5x4eJOh", "x7Ty5DTPxnBnMcXcwy3KP2vX4inB3UnNqsk0h6bjtzJoO")
#you should be up and running now and test the following commands out
search.string <- "#nba"
no.of.tweets <- 100
tweets <- searchTwitter(search.string, n = no.of.tweets, lang = "en")
tweets
