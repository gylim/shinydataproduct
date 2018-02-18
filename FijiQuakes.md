<style>
.lowright {
    position:fixed;
    top: 50%;
    left: 50%;
}
.small-code pre code {
  font-size: 0.6em;
}
large {
    font-size: 2em;
}
h2 {
    text-align:center;
}
</style>

Exploratory Analysis Enabler
========================================================
author: Benjamin Lim
date: 15 February 2018
autosize: true
font-family: 'Century Gothic'

The Problem...
========================================================
- Exploratory analysis is usually a <ins>black box</ins> for those without a programming background
- <ins>Trust</ins> whatever analysis your data team does for you

<b>But,</b>
- What if we could put the <strong> understanding of analysis </strong> back into the hands of the layman?
- <strong>Empower</strong> those without programming backgrounds to find significant patterns in data

App Background
========================================================
class: small-code
<small>Utilises the `quakes` data in R, containing location, depth, magnitude and number of stations for 1000 earthquakes around Fiji island.  

1. User input:  
    a. Select `lat` and `long` on sliders, `predictor` and `outcome` variables from dropdown  
    b. Select "I'm done fiddling" button to submit changes  
2. Server generates (i) leaflet map and (ii) plot with a linear model for the desired predictor vs. outcome. Coefficients, adjusted $R^2$ and mean squared error are automatically extracted. 

Following example is for <b>magnitude</b> as predictor and <b>stations</b> as outcome.

```r
lm(stations~mag, quakes) -> mdl
```
<strong>Intercept & Slope: </strong>-180.4243266, 46.2822108  
<strong>Adjusted $R^2$: </strong>0.7242355  
<strong>MSE: </strong>131.9995566</small>

Description of Operation
========================================================
class: small-code

```r
library(leaflet)
quakes$popup <- with(quakes, paste("Depth = ",depth,'<br>', "Magnitude = ",mag, '<br>',"Stations = ",stations))
pal <- colorNumeric("Reds", quakes$depth)
quakes %>% leaflet() %>% addTiles() %>% addCircles(lat = ~lat, lng = ~long, radius = ~10^mag/10, fillColor = ~pal(depth), fillOpacity = 0.5, weight = 1) %>% addLegend(position = "bottomleft", pal = pal, values = ~depth)
```
<div align="center">
<img src="leaflet.png" width=500 height=350>
</div>

***

```r
plot(quakes[,"mag"], quakes[,"stations"], pch = 16, bty = "n", col = grey(0, alpha = 0.5),xlab = "mag", ylab = "stations")
abline(mdl, col = "blue", lwd = 2)
```

![plot of chunk Bottom Panel](FijiQuakes-figure/Bottom Panel-1.png)
Future Work
========================================================
class: small-code

1. Include ability to generate other regression models (e.g. multiple regression) for exploring the data
2. Exploration of different data sets

<h2>Thank you!</h2>
