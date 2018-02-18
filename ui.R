library(shiny); library(leaflet)

shinyUI(fluidPage(
  
  titlePanel("Building Models for Fiji Earthquakes"), withMathJax(), 
  
  sidebarLayout(
    sidebarPanel(
        sliderInput("lat",
                   "Select the latitude:",
                   min = -39,
                   max = -10,
                   value = c(-39,-10)),
        sliderInput("lng",
                "Select the longitude:",
                min = 165,
                max = 190,
                value = c(165,190)),
        selectInput("predictor", "Select Predictor Variable:",
                    c("Latitude" = "lat",
                      "Longitude" = "long",
                      "Depth" = "depth",
                      "Magnitude" = "mag",
                      "Stations" = "stations")),
        selectInput("outcome", "Select Outcome Variable:",
                    c("Latitude" = "lat",
                      "Longitude" = "long",
                      "Depth" = "depth",
                      "Magnitude" = "mag",
                      "Stations" = "stations")),
        submitButton(text = "I'm done fiddling"),
        h3("Model Details"),
        h4("Coefficient of Slope:"),
        textOutput("slope"),
        h4("Coefficient of Intercept:"),
        textOutput("intercept"),
        h4("Adjusted R Squared Value: "),
        textOutput("rsquared"),
        h4("Mean Squared Error: "),
        textOutput("mse")
    ),
    mainPanel(
        leafletOutput("map"),
        plotOutput("graph")
    )
  )
))
