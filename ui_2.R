library(dplyr)
library(data.table)
library(ggplot2)
library(ggvis)
library(rgdal)
library(mapproj)
library(leaflet)
library(twitteR)
library(ggmap)
library(shiny)
library(htmltools)


my.ui <- navbarPage(
  title = "Twitter Analysis",
  tabPanel("Welcome",
           sidebarLayout(
             sidebarPanel(
               h2("About"),
               p("For this application, we used the ", code("twitteR"), " package, ", br(),
                 "which accesses the Twitter API.", br(), " Also used was the Google Maps API"),
               h3("Authors"),
               p("Alexander Harr", br(),
                "Julian Perkowski",br(), "Kelvin Kaholi")
             ),
             mainPanel(
               h1("Introducing Twitter Analysis"),
               p("Twitter Analysis is an application that allows you to",strong("search, view, and see popular"),
               "tweets and accounts"),
               br(),
               br(),
               img(src = "TwitterLogo.png", height = 500, width = 500)
             )
           )
           ),
  tabPanel(
    title ="Map",
    sidebarLayout(
      sidebarPanel(
        sliderInput("obs", label = "Number of Followers", min = 25, max = nrow(american_results), value = nrow(american_results)/2),
        selectInput("markers", label = "Choose a marker display", choices = c("Markers" ,"Circles"))
      ),
      mainPanel(
        leafletOutput("map")
      )
    )
  ),
  tabPanel(
    title = "Search",
    sidebarLayout(
      sidebarPanel(
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
                    max = 20)
      ),
      mainPanel(
        strong(p(textOutput('message'))),
        tableOutput("table")
      )
    )
  ),
  tabPanel(
    title = "Interest",
    sidebarLayout(
      sidebarPanel(
        em(p("Twitter's Interest")),
        #Categories that can describe different types of Twitter users
        selectInput("tweet_interest", "Your Interest?", 
                    c("Athlete" = "Athlete", "Brand" = "Brand", "Entertainer",
                      "Executive" = "Executive", "Media" = "Media", "Organization" = "Organization",
                      "Politician" = "Politician", "Sports Team"= "Sports Team", "Technology" = "Technology")
        ),
        #if it is Entertainer, this will pop up.
        conditionalPanel(
          condition = "input.tweet_interest == 'Entertainer'",
          selectInput("Entertainer_interest", "What type?", 
                      c("Comedian" = "Comedian", 
                        "Musician" = "Musician", "Reality Star" = "Reality Star", "TV Host" = "TV Host")
          )
        )
      ),
      mainPanel(
        tableOutput("interest.table")
      )
    )
  )
)


my.server <- function(input, output) {
  
}

shinyApp(my.ui, my.server)
