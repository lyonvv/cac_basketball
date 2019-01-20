library("httr")
library("rvest")
library("tidyverse")

#all_player_cac_df <-  




get_player_career_stats <- function(player_id) {
  url <- paste("https://www.cacbasketball.com/wordpress/player.php?pId=", player_id, sep= "")
  html <- (content(GET(url), "raw")) 
  
  player_name <- read_html(html) %>% 
    html_nodes("h1:nth-child(1)")  %>%
    html_text()
  
  stats <- read_html(html) %>% 
    html_nodes(".textBlackSmallStyle")  %>%
    html_text()
  
as.data.frame(matrix(stats[16:length(stats)], ncol=14, byrow=TRUE), stringsAsFactors = FALSE) %>% 
  mutate(player_name = player_name, player_id = player_id) %>%
  select(player_id, player_name, league = V1, games = V2, pts = V3, dreb = V4, oreb = V5, ast = V6, stl = V7, blk = V8, ftm = V9, fta = V10, `3pm` = V12, `3pa` = V13)
}



get_all_player_career_stats <- function(lower_limit, upper_limit){
  list_of_players <- list()
  
  for(i in lower_limit:upper_limit){
    stats <- get_player_career_stats(i)
    list_of_players[[i]] <- stats 
    if(i%%100 == 0){
      print(paste(i, "players completed"))
    }
    if(i%%100 == 0){
      print(Sys.time())
    }
  }
  
 bind_rows(list_of_players)
  
}



cac_player_stats_1_to_1000 <- get_all_player_career_stats(1, 1000)
cac_player_stats_1001_to_2000 <- get_all_player_career_stats(1001, 2000)
cac_player_stats_2001_to_3000 <- get_all_player_career_stats(2001, 3000)
cac_player_stats_3001_to_4000 <- get_all_player_career_stats(3001, 4000)
cac_player_stats_4001_to_5000 <- get_all_player_career_stats(4001, 5000)
cac_player_stats_5001_to_6000 <- get_all_player_career_stats(5001, 6000)
cac_player_stats_6001_to_7000 <- get_all_player_career_stats(6001, 7000)
cac_player_stats_7001_to_8000 <- get_all_player_career_stats(7001, 8000)
cac_player_stats_8001_to_9000 <- get_all_player_career_stats(8001, 9000)
cac_player_stats_9001_to_10000 <- get_all_player_career_stats(9001, 10000)
cac_player_stats_10001_to_11000 <- get_all_player_career_stats(10001, 11000)
cac_player_stats_11001_to_12000 <- get_all_player_career_stats(11001, 12000)
cac_player_stats_12001_to_13000 <- get_all_player_career_stats(12001, 13000)
cac_player_stats_13001_to_14000 <- get_all_player_career_stats(13001, 14000)
cac_player_stats_14001_to_15000 <- get_all_player_career_stats(14001, 15000)
cac_player_stats_15001_to_16000 <- get_all_player_career_stats(15001, 16000)
cac_player_stats_16001_to_17000 <- get_all_player_career_stats(16001, 17000)



all_dfs <- rbind(ac_player_stats_5001_to_6000, cac_player_stats_1_to_1000, cac_player_stats_1001_to_2000,
      cac_player_stats_2001_to_3000, cac_player_stats_3001_to_4000, cac_player_stats_4001_to_5000,
      cac_player_stats_6001_to_7000, cac_player_stats_8001_to_9000, cac_player_stats_9001_to_10000,
      cac_player_stats_10001_to_11000, cac_player_stats_11001_to_12000, cac_player_stats_12001_to_13000,
      cac_player_stats_13001_to_14000, cac_player_stats_14001_to_15000, cac_player_stats_15001_to_16000, 
      cac_player_stats_16001_to_17000)



write_csv(all_dfs, "~/Desktop/all_cac_players_ever_stats.csv")

#library("stringr")
#library("tidyr")


#test_league <- "A DRAFT S13Big Audio Dynamite"

#str_locate(test_league, "[0-9][A-Z]")[][1]

