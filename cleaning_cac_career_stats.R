library("tidyverse")

#takes and tidys an input from the scraped data
get_tidy_total_stats <- function(input_stats){
  input_stats %>% 
    filter(!is.na(player_name) & !is.na(league)) %>% 
    arrange(player_id) %>%
    mutate(league = str_extract(league, "^(.*?)[0-9][0-9][A-Z]"), session = str_extract(league, "[A-Za-z][0-9][0-9]"), 
           season = str_extract(session, "[A-Za-z]"), year = 2000 + as.numeric(str_extract(session, "[0-9][0-9]"))) %>%
    mutate(league = substr(league, 1, nchar(league)-1), level = str_trim(str_extract(league, ".+?(?=[SWF][0,1]\\d)"))) %>%
    filter(!is.na(level)) %>%
    mutate(pts = round(pts*games), dreb = round(dreb*games), oreb = round(oreb*games),
           ast = round(ast*games), stl = round(stl*games), blk = round(blk*games), 
           treb = dreb+oreb) %>%
    mutate(level = case_when( str_detect(level, "B1") ~ "B1 5v5", 
                              str_detect(level, "5v5 Draft") ~ "5v5 Draft", 
                              str_detect(level, "B2") & !str_detect(level, "4v4") ~ "B2 5v5",  
                              str_detect(level, "B2 4v4") ~ "B2 4v4", 
                              str_detect(level, "B Draft") & !str_detect(level, "Franchise B Draft") ~ "B Draft 4v4", 
                              str_detect(level, "Corporate") ~ "Corporate 5v5", 
                              str_detect(level, "Co-Ed") | str_detect(level, "CoEd") ~ "Co-Ed", 
                              str_detect(level, "THE Franchise") | str_detect(level, "Franchise B") ~ "Franchise B Draft 4v4", 
                              str_detect(level, "OVER") ~ "Over 30 Draft 4v4", 
                              str_detect(level, "Sat Draft") | str_detect(level, "SDL") ~ "Saturday Draft 4v4", 
                              str_detect(level, "Franchise A Draft") | str_detect(level, "Franchise Draft") | str_detect(level, "A2") | str_detect(level, "A1 Draft")| str_detect(level, "A Draft")| str_detect(level, "A DRAFT") ~ "A Draft 4v4", 
                              str_detect(level, "Women's") | str_detect(level, "W5v5") ~ "Women's 5v5",
                              str_detect(level, "W4v4") ~ "Women's 4v4",
                              TRUE ~ level), 
           is_draft_league = case_when(str_detect(level, "Draft") ~ TRUE, TRUE ~ FALSE), 
           level_play_type = case_when(str_detect(level, "4v4") ~ "4v4", str_detect(level, "5v5") ~ "5v5", TRUE ~ "Unknown"), 
           level_gender = case_when(str_detect(level, "Women's") ~ "Women",
                              str_detect(level, "Co-Ed") ~ "Co-Ed",
                              TRUE ~ "Men"),
                            
  
        
           level_rank = case_when(level == "A 5v5" ~ 1,
                                  level == "B1 5v5" ~ 2,
                                  level == "A Draft 4v4" ~ 3,
                                  level == "B2 5v5" ~ 4,
                                  level == "5v5 Draft" ~ 5,
                                  level == "Corporate 5v5" ~ 6,
                                  level == "B2 4v4" ~ 7,
                                  level == "Saturday Draft 4v4" ~ 8,
                                  level == "Franchise B Draft" ~ 9,
                                  level == "B Draft 4v4" ~ 10,
                                  level == "Over 30 Draft 4v4" ~ 11,
                                  level == "Co-Ed 5v5" ~ 12,
                                  level == "Sunday Night 5v5" ~ 13,
                                  level == "Sunday AM" ~ 14,
                                  level == "Women's 5v5" ~ 15 ,
                                  level == "Women's 4v4" ~ 16, 
                                  TRUE ~ 17)) %>%
    select(player_id, player_name, level, is_draft_league, level_play_type, level_gender, season, year, 
           games, `3pm`, `3pa`, ftm, fta, oreb, dreb, treb, ast, stl, blk, pts)
}
