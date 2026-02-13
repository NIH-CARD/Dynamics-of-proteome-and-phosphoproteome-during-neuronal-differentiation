# Phosphoproteome Temporal Dynamics Web App

This repository contains the scripts and resources associated with our publication in Science Signaling.

In this study, we assessed the dynamic changes of kinases that are critical for neuronal development and maturation. We generated a high-resolution temporal phosphoproteomic dataset and developed an interactive web application to visualize the temporal landscape of protein and phosphosite abundance.

The companion web application is publicly available at:
👉 https://niacard.shinyapps.io/Phosphoproteome/

Users can either:

- Explore the data directly via the hosted web application

- Download this repository and run the application locally

# 1. Running Locally
Clone the repository
```R
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
cd YOUR_REPOSITORY
```

# 2.Install required R packages
Open R and install required packages:
```R
install.packages(c("shiny", "tidyverse", "data.table", "ggplot2", 
                   "DT", "plotly"))
```

# 3.Run the app
```R
library(shiny)
runApp("app")
```
or simply open app.R in RStudio and click Run App.

