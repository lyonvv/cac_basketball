library("tidyverse")

source("~/Desktop/r_projects/cac_basketball/cleaning_cac_career_stats.R")

raw_stats <- read_csv("~/Desktop/r_projects/cac_basketball/all_cac_players_ever_stats.csv")

tidy_stats <- get_tidy_total_stats(raw_stats)

#takes a grouped data frame and adds up total stats, could be used for career, 
#or just for a specific subset, for example, for a specific level
get_totals <- function(grouped_input_stats){
    summarise(grouped_input_stats, games = sum(games), `3pm` = sum(`3pm`), `3pa` = sum(`3pa`),
              ftm = sum(ftm), fta = sum(fta), oreb = sum(oreb), dreb = sum(dreb),
              treb = sum(treb), ast = sum(ast), stl = sum(stl), blk = sum(blk), pts = sum(pts))
}



#takes stat totals and retuns per game averages
get_per_game_averages <- function(input_stats_totals){
  input_stats_totals %>% transmute(player_name = player_name, 
                            games = games,
                            ppg = round(pts / games, digits = 1),
                            orpg = round(oreb / games, digits = 1),
                            drpg = round(dreb / games, digits = 1),
                            trpg = round(treb / games, digits = 1),
                            apg = round(ast / games, digits = 1),
                            spg = round(stl / games, digits = 1),
                            bpg = round(blk / games, digits = 1),
                            `3pm` = round(`3pm` / games, digits = 1),
                            `3pa` = round(`3pa` / games, digits = 1),
                            `3pct` = round(`3pm`/`3pa`, digits = 3),
                            ftm = round(ftm / games, digits = 1),
                            fta = round(fta / games, digits = 1),
                            ftpct = round(ftm/fta, digits = 3)
  )
}


#`3pct_percentile_values` <- quantile(a_draft_all_seasons[[12]], probs = seq(0, 1, 0.01), na.rm = FALSE, names = TRUE)



#`3pct_percentiles` <- as_tibble(0:100) %>% rename(percentile = value) %>% cbind(as_tibble(`3pct_percentile_values`)) %>% 
#  mutate(next_percentile_value = lead(value, 1))
