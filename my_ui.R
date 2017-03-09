library("shiny")
library("ggplot2")
library("dplyr")

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
      
      em(p("Kelvin's Thingy Options"))
      
      ),
    
    # making the main panel
    mainPanel(
      
      # creating the tabs
      tabsetPanel(type = "tabs",
                  tabPanel("Map"), 
                  tabPanel("Search", strong(p(textOutput('message'))), tableOutput("table")), 
                  tabPanel("Kelvin's Thing")
      )
    )
  )
)
