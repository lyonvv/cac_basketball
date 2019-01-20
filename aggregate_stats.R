library("tidyverse")


get_career_totals <- function(input_stats){
  input_stats %>%
    group_by(player_id, player_name) %>% 
    summarise(games = sum(games), `3pm` = sum(`3pm`), `3pa` = sum(`3pa`),
              ftm = sum(ftm), fta = sum(fta), oreb = sum(oreb), dreb = sum(dreb),
              treb = sum(treb), ast = sum(ast), stl = sum(stl), blk = sum(blk), pts = sum(pts))
}

get_career_totals(a_draft_stats)

get_per_game_averages <- function(input_stats){
  input_stats %>% transmute(player_name = player_name, 
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


career_a_draft_stats <- arrange(filter(get_per_game_averages(get_career_totals(a_draft_stats)), games > 9 ), desc(ppg))

a_draft_all_seasons 

test <- arrange(a_draft_all_seasons, desc(ppg)) %>% mutate(rank = )
test

a_draft_all_seasons <- filter(a_draft_stats, games > 5, `3pa` > 2)





`3pct_percentile_values` <- quantile(a_draft_all_seasons[[12]], probs = seq(0, 1, 0.01), na.rm = FALSE, names = TRUE)



`3pct_percentiles` <- as_tibble(0:100) %>% rename(percentile = value) %>% cbind(as_tibble(`3pct_percentile_values`)) %>% 
  mutate(next_percentile_value = lead(value, 1))
