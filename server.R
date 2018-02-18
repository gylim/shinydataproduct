library(shiny); library(leaflet); library(dplyr)

shinyServer(function(input, output) {
    data("quakes")
    quakes$popup <- with(quakes, paste("Depth = ",depth,'<br>',
                          "Magnitude = ",mag, '<br>',
                          "Stations = ",stations))
    pal <- colorNumeric("Reds", quakes$depth)
    small <- reactive({quakes %>% filter(between(lat,input$lat[1],input$lat[2])&
                          between(long,input$lng[1],input$lng[2]))
    })
    output$map <- renderLeaflet({
        leaflet(small()) %>% addProviderTiles("Stamen.Terrain") %>%
            addCircles(lat = ~lat, lng = ~long, radius = ~10^mag/10, 
                       fillColor = ~pal(depth), fillOpacity = 0.5, 
                       weight = 1, popup = ~popup) %>% 
            addLegend(position = "bottomleft", pal = pal, values = ~depth)
    })
    model <- reactive({
        if(input$outcome != input$predictor){
            y <- input$outcome
            x <- input$predictor
            sm <- small()
            lm(sm[,y]~sm[,x], data = sm)
        }
    })
    output$graph <- renderPlot({
        sm <- small()
        mdl <- model()
        
        plot(sm[,input$predictor], sm[,input$outcome], 
             pch = 16, bty = "n", col = grey(0, alpha = 0.5), 
             xlab = input$predictor, ylab = input$outcome)
        if(input$outcome != input$predictor){
            abline(mdl, col = "blue", lwd = 2)
        }
    })
    output$slope <- renderText({
        if(input$outcome != input$predictor){
            mdl <- model()
            summary(mdl)$coefficients[2]
        }else{"Please select different predictor/outcome"}
    })
    output$intercept <- renderText({
        if(input$outcome != input$predictor){
            mdl <- model()
            summary(mdl)$coefficients[1]
        }else{"Please select different predictor/outcome"}
    })
    output$rsquared <- renderText({
        if(input$outcome != input$predictor){
            mdl <- model()
            summary(mdl)$adj.r.squared
        }else{"Please select different predictor/outcome"}
    })
    output$mse <- renderText({
        if(input$outcome != input$predictor){
            mdl <- model()
            mean(summary(mdl)$residuals^2)
        }else{"Please select different predictor/outcome"}
    })
})
