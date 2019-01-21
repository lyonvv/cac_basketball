library(shiny)
library(tidyverse)
library(DT)

a_Draft_player_stats <- read_csv("a_draft_2019_career_averages_for_shiny.csv")


ui <- fluidPage(
  titlePanel("A Draft 2019 Player Stats"),
  sidebarLayout(
    sidebarPanel(radioButtons("hide_selected", "Hide Selected", c("Hide" = 0,
                                                                  "Show" = 1),
                              selected = 0),
                 radioButtons("hide_captains", "Hide Captains", c("Hide" = 0,
                                                                  "Show" = 1),
                              selected = 1),
                 radioButtons("hide_rookies", "Hide Rookies", c("Hide" = 0,
                                                                "Show" = 1),
                              selected = 1),
                 
                 checkboxGroupInput("position_select", "Positions", c("Guards" = 1, 
                                                                      "Wings" = 2, 
                                                                      "Bigs" = 3),
                                    selected = c(1,2,3))
                
                 ),
    mainPanel(DTOutput("stats_table"))
  )
  
)

