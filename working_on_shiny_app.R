library("shiny")
library(DT)

source("~/Desktop/r_projects/cac_basketball/cleaning_cac_career_stats.R")
source("~/Desktop/r_projects/cac_basketball/aggregate_stats.R")




test_case <- read_csv("~/Desktop/r_projects/cac_basketball/all_cac_players_ever_stats.csv") %>% 
  get_tidy_total_stats() %>% 
  filter(level == "A Draft 4v4") %>%
  group_by(player_id, player_name) %>%
  get_totals() %>%
  get_per_game_averages() %>% 
  get_stats_with_percentiles() %>%
  filter(player_name %in% read_csv("~/Desktop/r_projects/cac_basketball/2019_a_draft_player_list.csv")[[1]])






datatable(filter(a_draft_19_stats_with_percentiles), 
          class = 'cell-border compact hover',
         
          options=list(columnDefs = list(list(visible=FALSE, targets=c(0, 1, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29))))) %>%
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
  
  

  
  
