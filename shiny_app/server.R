library(shiny)
library(tidyverse)
library(DT)







format_percentiles <- function(data, column_name_with_value, column_name_to_color){
  formatStyle(
    data,
    column_name_with_value,
    column_name_to_color,
    color = styleInterval(c(10, 20, 30, 40, 50, 60, 70, 80, 90), c('#ff0000', '#cc0033', '#a60059', '#8c0073', '#800080', '#73008c', '#5900a6', '#4000bf',  '#2600d9', '#0000ff')),
    fontWeight = 'bold'
  )
}

server <- function(input, output) {
  a_draft_player_stats <- read_csv("a_draft_2019_career_averages_for_shiny.csv")
  a_draft_players_metadata <- read_csv("~/Desktop/r_projects/cac_basketball/data/2019_a_draft_player_list.csv")
  
  stats_and_metadata <- right_join(a_draft_player_stats, a_draft_players_metadata) %>%
    filter(is.na(player_id) | player_id != 1073)  
  
  output$stats_table = renderDT({
    datatable(
      if (input$hide_selected == 0){
        
       filter(stats_and_metadata, 
             input$hide_captains >= is_captain, 
             input$hide_rookies >= is_rookie,
             position %in% input$position_select) %>% 
          filter(is.na(price)) %>%
          arrange(my_rank)
      }
      else{
      filter(stats_and_metadata, 
             input$hide_captains >= is_captain, 
             input$hide_rookies >= is_rookie,
             position %in% input$position_select) %>%
          arrange(my_rank)
      },
      
              class = 'cell-border compact hover',
              options=list(columnDefs = list(list(visible=FALSE, targets=c(0, 1, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 30, 31, 32, 33, 34, 35, 36))))
    ) %>%
      format_percentiles("ppg", "ppg_tile") %>%
      format_percentiles("orpg", "orpg_tile") %>%
      format_percentiles("drpg","drpg_tile") %>% 
      format_percentiles("trpg", "trpg_tile") %>%
      format_percentiles("apg", "apg_tile") %>%
      format_percentiles("spg", "spg_tile") %>%
      format_percentiles("bpg", "bpg_tile") %>%
      format_percentiles("3pm", "3pm_tile") %>%
      format_percentiles("3pa", "3pa_tile") %>%
      format_percentiles("3pct", "3pct_tile") %>%
      format_percentiles("ftm", "ftm_tile") %>%
      format_percentiles("fta", "fta_tile") %>%
      format_percentiles("ftpct", "ftpct_tile")
    
  })
}
