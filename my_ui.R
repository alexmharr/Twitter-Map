library("shiny")
library("ggplot2")
library("dplyr")
source("interactive_map.R")
# creating the ui
my.ui <- fluidPage(

  # creating the title
  titlePanel("Twitter Data App"),
  p("By: Alex Harr, Julian Perkowski, and Kelvin Kaholi"),
  sidebarLayout(
    
    # making the sidebar panel
    sidebarPanel(
      em(p("Map Options")),
      
      br(),
      
      em(p("Search Options")),
      
      selectInput('type', "Search Type:",
                  c("Twitter Handle" = 'a', "Trend" = 'b')),
      
      selectInput('sort', "Sort Results By:",
                  c("Most Recent" = 'a', "Most Popular" = 'b', "Mixed" = 'c')),
      
      textInput('search', label = "Search Box:"),
      
      sliderInput('tweets', 
                  "Number of Tweets Displayed:", 
                  value = 10,
                  min = 1, 
                  max = 20),
      br(),
      

      em(p("Twitter's Interest")),
      
      #Categories that can describe different types of Twitter users
      selectInput("tweet_interest", "Your Interest?", 
                  c("Athlete" = "Athlete", "Brand" = "Brand", "Entertainer",
                    "Executive" = "Executive", "Media" = "Media", "Organization" = "Organization",
                    "Politician" = "Politician", "Sports Team"= "Sports Team", "Technology" = "Technology")
                  ),
      sliderInput("obs", label = "Number of Followers", min = 25, max = nrow(american_results), value = nrow(american_results)/2),
      selectInput("markers", label = "Choose a marker display", choices = c("Markers" ,"Circles")), 
      #if it is Entertainer, this will pop up.
      conditionalPanel(
        condition = "input.tweet_interest == 'Entertainer'",
        selectInput("Entertainer_interest", "What type?", 
                    c("Comedian" = "Comedian", 
                      "Musician" = "Musician", "Reality Star" = "Reality Star", "TV Host" = "TV Host")
        )
      )
    ),
    
    # making the main panel
    mainPanel(

      # creating the tabs
      tabsetPanel(type = "tabs",
                  tabPanel("Map", leafletOutput("map")), 
                  tabPanel("Search", strong(p(textOutput('message'))), tableOutput("table")), 
                  tabPanel("Interest", tableOutput("interest.table"))

      )
    )
  )
)
shinyUI(my.ui)
