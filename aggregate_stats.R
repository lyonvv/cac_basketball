library("tidyverse")

source("~/Desktop/r_projects/cac_basketball/cleaning_cac_career_stats.R")


#takes a grouped data frame and adds up total stats, could be used for career, 
#or just for a specific subset, for example, for a specific level
get_totals <- function(grouped_input_stats){
    summarise(grouped_input_stats, games = sum(games), `3pm` = sum(`3pm`), `3pa` = sum(`3pa`),
              ftm = sum(ftm), fta = sum(fta), oreb = sum(oreb), dreb = sum(dreb),
              treb = sum(treb), ast = sum(ast), stl = sum(stl), blk = sum(blk), pts = sum(pts), `3pct` = round(`3pm`/`3pa`, digits = 3), `ftpct` = round(`ftm`/`fta`, digits = 3) )
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
  ) %>%
    mutate(`3pct` = case_when(is.na(`3pct`) ~ 0, TRUE ~ `3pct` ),
           ftpct = case_when(is.na(`ftpct`) ~ 0, TRUE ~ ftpct))
}


#takes a dataframe with grouped data (either total or average) and a column number
get_percentile_values <- function(data, stat_column_number){
  percentiles <-as_data_frame(quantile(data[[stat_column_number]], probs = seq(0, 1, 0.01))) %>% 
    mutate(next_value = lead(value)) %>%
    cbind(data.frame(percentile = 0:100))
}



get_percentile  <- function(data, test_value, stat_column_number){
  if(is.na(test_value)){
    0
  }
  else{
    filter(get_percentile_values(data, stat_column_number), test_value >=  value & (test_value < next_value | is.na(next_value)))$percentile
  }
}



get_stats_with_percentiles <- function(input_stats){ 
  
  
  input_stats %>% 
    rowwise() %>%
    mutate(ppg_tile = get_percentile(input_stats, ppg, 4),
           orpg_tile = get_percentile(input_stats, orpg, 5),
           drpg_tile = get_percentile(input_stats, drpg, 6),
           trpg_tile = get_percentile(input_stats, trpg, 7),
           apg_tile = get_percentile(input_stats, apg, 8),
           spg_tile = get_percentile(input_stats, spg, 9),
           bpg_tile = get_percentile(input_stats, bpg, 10),
           `3pm_tile` = get_percentile(input_stats, `3pm`, 11),
           `3pa_tile` = get_percentile(input_stats, `3pa`, 12),
           `3pct_tile` = get_percentile(input_stats, `3pct`, 13),
           ftm_tile = get_percentile(input_stats, ftm, 14),
           fta_tile = get_percentile(input_stats, fta, 15),
           `ftpct_tile` = get_percentile(input_stats, ftpct, 16)
           
           
           
           #na.rm = TRUE
     )%>%
    select(player_id, player_name, games, ppg, ppg_tile, orpg, orpg_tile, 
           drpg, drpg_tile, trpg, trpg_tile, apg, apg_tile, spg, spg_tile, 
            bpg, bpg_tile, `3pm`, `3pm_tile`, `3pa`, `3pa_tile`, `3pct`, `3pct_tile`, ftm, ftm_tile, fta, fta_tile, ftpct, ftpct_tile)
}




#not sure if this should go here, but it's a good place for now
format_percentiles <- function(data, column_name_with_value, column_name_to_color){
  formatStyle(
    data,
    column_name_with_value,
    column_name_to_color,
    color = styleInterval(c(10, 20, 30, 40, 50, 60, 70, 80, 90), c('#ff0000', '#cc0033', '#a60059', '#8c0073', '#800080', '#73008c', '#5900a6', '#4000bf',  '#2600d9', '#0000ff')),
    fontWeight = 'bold'
  )
}


get_2019_a_draft_stats <- function(raw_stats){
raw_stats %>% 
  get_tidy_total_stats() %>% 
  filter(level == "A Draft 4v4") %>%
  group_by(player_id, player_name) %>%
  get_totals() %>%
  get_per_game_averages() %>% 
  get_stats_with_percentiles() %>%
  filter(player_name %in% read_csv("~/Desktop/r_projects/cac_basketball/data/2019_a_draft_player_list.csv")[[1]])
}



