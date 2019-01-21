library("httr")
library("rvest")
library("tidyverse")


#gets each season stats for player, based on player_id
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


#gets all season stats for a range of players, from lower_limit id to upper_limit id
get_many_player_career_stats <- function(lower_limit, upper_limit){
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


rbind(get_many_player_career_stats(7001, 8000), read_csv("~/Desktop/r_projects/cac_basketball/data/all_cac_raw.csv")) %>% 
  arrange(player_id) %>%
  write_csv("~/Desktop/r_projects/cac_basketball/data/all_cac_raw.csv")
