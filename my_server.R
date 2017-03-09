library("shiny")
library("ggplot2")
library("dplyr")
library("twitteR")
library("ROAuth")
source("interactive_map.R")

setup_twitter_oauth("APMnFSmvPJ56HLqRlO957IpNa", "6Ra0pjhVcqQl64ArBrQtY6jUCraqJYrLA9bTs9MmFv7no3V8Zp", 
                    "2340813607-fJqGczp5N7NhyrcGfoMR8Hx0yEc3UhOO5x4eJOh", "x7Ty5DTPxnBnMcXcwy3KP2vX4inB3UnNqsk0h6bjtzJoO")

# creating the server
my.server <- function(input, output) {
  
  total <- reactive({
    followers <- american_results %>% 
      sample_n(input$obs)
    return(followers)
  })
  
  radius <- reactive({
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
    getRadius(total())
  })
  
  friends <- reactive({
    total()$friends
  })
  
  output$map <- renderLeaflet({
    binPal <- colorQuantile("Blues", total()$friends, n = 7)
    l <- leaflet() %>%
      addTiles() %>% 
      addProviderTiles(providers$Esri.WorldStreetMap) %>% 
      setView(lng = -98.35, lat = 39.5, zoom = 3)
    if(input$markers == "Markers") {
      l <- l %>% addMarkers(data = total(), lng = ~lng, lat = ~lat, label = ~htmlEscape(screenName))
    } else {
      l <- l %>%  addCircleMarkers(data = total(), radius = radius(), color = binPal(friends()), stroke = FALSE, fillOpacity = 0.5)
    }
    return(l)
  })
  
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
  #storing reactive Values  here
  data <- reactiveValues()
  data$interest <- ""
  output$interest.table <- renderTable({
    #this csv is from 'fanpagelist.com/category/top_users/view/list/sort/followers/', not an api.
    top100.user <- read.csv("top100 twitter user.csv")
    if (input$tweet_interest == "Entertainer"){
      data$interest <- input$Entertainer_interest
    }
    #filtering the table with the reactive values
    top100.category <- top100.user[grep(data$interest, top100.user$Categories),]
  })
  
  observeEvent(input$tweet_interest, {data$interest <- input$tweet_interest})

}
shinyServer(my.server)

