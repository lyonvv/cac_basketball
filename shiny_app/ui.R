library(shiny)
library(DT)



a_draft_players <- read_csv("~/Desktop/r_projects/cac_basketball/2019_a_draft_player_list.csv")[1] %>%
  arrange(player_name)



# Define UI for miles per gallon application
shinyUI(
    #DTOutput("mytable")
    #plotOutput("rebounding_plot"),
   plotOutput("free_throw_plot")
  )
)

