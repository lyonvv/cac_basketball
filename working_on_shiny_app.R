library("tidyverse")
library("fmsb")



source("~/Desktop/r_projects/cac_basketball/aggregate_stats.R")
source("~/Desktop/r_projects/cac_basketball/cleaning_cac_career_stats.R")

a_draft_stats <- read_csv("~/Desktop/r_projects/cac_basketball/all_cac_players_ever_stats.csv") %>% 
  get_tidy_total_stats() %>% 
  filter(level == "A Draft 4v4") %>%
  group_by(player_id, player_name) %>%
  get_totals() %>%
  get_per_game_averages() %>% 
  get_stats_with_percentiles() 

a_draft_2019_stats <- a_draft_stats %>%
  filter(player_name %in% read_csv("~/Desktop/r_projects/cac_basketball/2019_a_draft_player_list.csv")[[1]])



three_point_volume_and_accuracy_plot <- function(player_name_input){ 
ggplot(a_draft_stats, aes(`3pct`, `3pa`)) +
  geom_point(color = "#D3D3D3", size = 5, alpha = .5) +
  geom_point(data = filter(a_draft_stats, player_name == player_name_input), color = "red", size = 5)
}



