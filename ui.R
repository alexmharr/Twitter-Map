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

source("interactive_map.R")

my.ui <- fluidPage(
  titlePanel("Map"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", label = "Number of Followers", min = 25, max = nrow(american_results), value = nrow(american_results)/2),
      selectInput("markers", label = "Choose a marker display", choices = c("Markers" ,"Circles"))
    ),
    mainPanel(
      leafletOutput("map")
    )
  )
)

my.server <- function(input, output, session) {
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
}

shinyApp(my.ui, my.server)






