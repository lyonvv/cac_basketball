library("shiny")
library(DT)

source("~/Desktop/r_projects/cac_basketball/cleaning_cac_career_stats.R")
source("~/Desktop/r_projects/cac_basketball/aggregate_stats.R")

stats <- read_csv("~/Desktop/r_projects/cac_basketball/a_draft_2019_career_averages_for_shiny.csv")

shinyApp(
ui = DTOutput("mytable"),

server = function(input, output) {
  output$mytable = renderDT({
    datatable(filter(stats), 
              class = 'cell-border compact hover',
              options=list(columnDefs = list(list(visible=FALSE, targets=c(0, 1, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29))))
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




)



                
                
                
       