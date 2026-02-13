###########################
#CARD challenge phospho-proteomics longitudinal
#Sep-2024
#Ziyi Li
#CARD NIH
#########################
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(ggplot2)
library(ggiraph)
library(shiny)
library(shinyWidgets)
library(dplyr)

# Read data
total_data_long=read.csv('total_data_long.csv')%>%
  filter(value > 1)%>%
  filter(Genes != '')

phospho_data_long=read.csv('phospho_data_long.csv')%>%
  filter(value > 1)%>%
  filter(Genes != '')

# Define UI
ui <- fluidPage(
  titlePanel("Temporal dynamics of proteome and phosphorproteome during neuronal differentiation in the reference KOLF2.1J iPSC line"),
  
  tabsetPanel(type = "tabs",
              
              # Page 1: Protein expression
              tabPanel("Proteome",
                       sidebarLayout(
                         sidebarPanel(
                           multiInput(
                             inputId = "Protein",
                             label = "Protein:",
                             choices = total_data_long$Genes %>% unique(),
                             selected = c("MAPT")
                           ),
                           p("Shiny app created by Ziyi Li")
                         ),
                         mainPanel(
                           girafeOutput("plot1")
                         )
                       )
              ),
              
              # Page 2: Phosphoprotein expression
              tabPanel("Phosphoproteome",
                       sidebarLayout(
                         sidebarPanel(
                           multiInput(
                             inputId = "Phosphosite",
                             label = "Phosphosite:",
                             choices = phospho_data_long$PTM %>% unique(),
                             selected = c("MAPT(S501)","MAPT(T498)")
                           )
                         ),
                         mainPanel(
                           girafeOutput("plot2")
                         )
                       )
              )
  )
)

# Define server
server <- function(input, output, session) {
  
  
  # Plot 1: Protein
  output$plot1 <- renderGirafe({
    girafe(code = print(
      total_data_long %>%
        filter(Genes %in% input$Protein) %>%
        ggplot(aes(x = Time, y = log2(value + 1), group = Genes, color = Genes)) +
        stat_summary(fun = mean, geom = "point") +
        stat_summary(fun = mean, fun.min = function(x) mean(x) - sd(x), 
                     fun.max = function(x) mean(x) + sd(x),
                     geom = "errorbar", width = 0.2) +
        stat_summary(fun = mean, geom = "line") +
        theme_classic() +
        labs(x = "Days after differentiation",
             y = "Log2 protein abundance",
             color = "Protein")
    ))
  })
  
  # Plot 2: Phosphoprotein
  output$plot2 <- renderGirafe({
    girafe(code = print(
      phospho_data_long %>%
        filter(PTM %in% input$Phosphosite) %>%
        ggplot(aes(x = Time, y = log2(value + 1), group = PTM, color = PTM)) +
        stat_summary(fun = mean, geom = "point") +
        stat_summary(fun = mean, fun.min = function(x) mean(x) - sd(x), 
                     fun.max = function(x) mean(x) + sd(x),
                     geom = "errorbar", width = 0.2) +
        stat_summary(fun = mean, geom = "line") +
        theme_classic() +
        labs(x = "Days after differentiation",
             y = "Log2 Phosphosite abundance",
             color = "PTM Location") +
        facet_wrap(~ PTM, ncol = 4) +
        theme(legend.position = 'none')
    ))
  })
}

# Run
shinyApp(ui = ui, server = server)

