library("shiny")

# load the UI and Server
source('my_ui.R')
source('my_server.R')

# create the app
shinyApp(ui = my.ui, server = my.server)