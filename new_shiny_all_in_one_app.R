library(shiny)
library(tidyverse)

source("~/Desktop/r_projects/cac_basketball/cleaning_cac_career_stats.R")
source("~/Desktop/r_projects/cac_basketball/aggregate_stats.R")

a_draft_stats <- read_csv("~/Desktop/r_projects/cac_basketball/all_cac_players_ever_stats.csv") %>% 
  get_tidy_total_stats() %>% 
  filter(level == "A Draft 4v4") %>%
  group_by(player_id, player_name) %>%
  get_totals() %>%
  get_per_game_averages() %>% 
  get_stats_with_percentiles()


# Define UI ----
ui <- fluidPage(
  titlePanel("title panel"),
  
  sidebarLayout(
    sidebarPanel(selectInput(inputId = "player",
                             label = "Choose a dataset:",
                             choices = read_csv("~/Desktop/r_projects/cac_basketball/2019_a_draft_player_list.csv")[1] %>%
                               arrange(player_name))
                 
                 
                 ),
    mainPanel(plotOutput(outputId = "three_point_plot")
              
              )
  )
  
)

# Define server logic ----
server <- function(input, output) {
  
  output$three_point_plot <- renderPlot(
    
    ggplot(a_draft_stats, aes(`3pct`, `3pa`)) +
      geom_point(color = "#D3D3D3", size = 5, alpha = .5) +
      geom_point(data = filter(a_draft_stats, player_name == input$player), color = "red", size = 5) +
      scale_x_continuous(limits = c(.1, .75)) +
      scale_y_continuous(limits = c(.1, 15)) +
      geom_text(data = filter(a_draft_stats, player_name == input$player), aes(label = (filter(a_draft_stats, player_name == input$player))$player_name), nudge_x = 0.06)
    
  )
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
