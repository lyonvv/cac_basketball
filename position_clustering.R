library(shiny)
library(tidyverse)
library(stats)

source("~/Desktop/r_projects/cac_basketball/cleaning_cac_career_stats.R")
source("~/Desktop/r_projects/cac_basketball/aggregate_stats.R")

a_draft_stats <- read_csv("~/Desktop/r_projects/cac_basketball/all_a_draft_stats_ever_stats.csv")
  

a_draft_stats_for_kmeans <- filter(a_draft_stats, games > 5) %>% 
  mutate(total_tile = ppg_tile + orpg_tile + drpg_tile + trpg_tile + apg_tile + spg_tile + bpg_tile + `3pa_tile` + `3pct_tile` + 
                          fta_tile + ftpct_tile, total_tile, ppg_tile = ppg_tile/total_tile, orpg_tile = orpg_tile/total_tile, drpg_tile = drpg_tile/total_tile,
        trpg_tile = trpg_tile/total_tile, apg_tile = apg_tile/total_tile, spg_tile = spg_tile/total_tile, bpg_tile = bpg_tile/total_tile, `3pa_tile` = `3pa_tile`/total_tile, `3pct_tile` = `3pct_tile`/total_tile, 
         fta_tile = fta_tile/total_tile, ftpct_tile = ftpct_tile/total_tile) %>%
  select(total_tile, ppg_tile, orpg_tile, drpg_tile, trpg_tile, apg_tile, spg_tile, bpg_tile, `3pa_tile`, `3pct_tile`, 
         fta_tile, ftpct_tile) 

a_draft_stats_six_or_more_games <- filter(a_draft_stats, games > 5) %>%
  cbind(kmeans(a_draft_stats_for_kmeans, 10)[1]) %>%
  select(player_name, cluster) %>%
  filter(player_name %in% read_csv("~/Desktop/r_projects/cac_basketball/2019_a_draft_player_list.csv")[[1]])




