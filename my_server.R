library("shiny")
library("ggplot2")
library("dplyr")
library("twitteR")
library("ROAuth")

setup_twitter_oauth("APMnFSmvPJ56HLqRlO957IpNa", "6Ra0pjhVcqQl64ArBrQtY6jUCraqJYrLA9bTs9MmFv7no3V8Zp", 
                    "2340813607-fJqGczp5N7NhyrcGfoMR8Hx0yEc3UhOO5x4eJOh", "x7Ty5DTPxnBnMcXcwy3KP2vX4inB3UnNqsk0h6bjtzJoO")

# creating the server
my.server <- function(input, output) {

  # determining options for table
  output$table <- renderTable({
    
    if(input$sort=='a'){
      result.type <- "recent"
    }
    if(input$sort=='b'){
      result.type <- "popular"
    }
    if(input$sort=='c'){
      result.type <- "mixed"
    }
    
    if(input$type=='a'){
      search.type <- "from:"
    }
    if(input$type=='b'){
      search.type <- "#"
    }
    
    search.string <- paste(search.type, input$search, sep = "")
    no.of.tweets <- input$tweets
    tweets <- searchTwitter(search.string, n = no.of.tweets, lang = "en", resultType = result.type)
    tweetsDF <- twListToDF(tweets)
    tweetsDF <- select(tweetsDF, screenName, text, created, retweetCount, favoriteCount)
    names(tweetsDF)[1] <- "Twitter Handle"
    names(tweetsDF)[2] <- "Text"
    names(tweetsDF)[3] <- "Date Created"
    names(tweetsDF)[4] <- "Number of Retweets"
    names(tweetsDF)[5] <- "Number of Favorites"
    
    # displaying table results
    tweetsDF
  })
  
  output$message <- renderText({
    table.message <- "Results displayed from the last week"
    # returning message for tables
    return(table.message)
  })
}

