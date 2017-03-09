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
library(rsconnect)
american_results <- read.csv("american_results", stringsAsFactors = FALSE)

ui <- navbarPage(
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
               "tweets and accounts. This provides a useful tool for prospective University of Washington students to see 
               where everyone lives, and also maintain a social aspect of staying up to date with the latest tweets"),
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
        h2("University Of Washington Follower Locations"),
        br(),
        p("The map below showcases the location of different University of Washington Followers"),
        p(""),
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
                    value = 2,
                    min = 1, 
                    max = 5)
      ),
      mainPanel(
        h2("Twitter Search"),
        p("This section of our app lets the user search the Twitter API for both specific users and trends. 
          The user is also given the option of how many results they want to be displayed.  
          Depending on which options the user selects, the server will run through the Twitter API,
          convert the resulting data list into a dataframe, select the relevant columns, 
          and finally display the results to the user."),
        tableOutput("table"),
        em(p(textOutput('message')))
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
        h2("Search for top accounts to follow based on your interest"),
        br(),
        p("Based off of a fanpage list, we were able to take the top 100 accounts on twitter.
          Then we separated the twitter users into different categories.
          The user of our app can search the top accounts on twitter based on these categories/interests."),
        tableOutput("interest.table")
      )
    )
  )
)



shinyServer(ui)
