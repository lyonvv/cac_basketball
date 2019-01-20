library(shiny)
library(DT)



a_draft_stats <- read_csv("~/Desktop/r_projects/cac_basketball/a_draft_career_averages_for_shiny.csv")
a_draft_players <- read_csv("~/Desktop/r_projects/cac_basketball/2019_a_draft_player_list.csv")


# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  # Compute the forumla text in a reactive expression since it is 
  # shared by the output$caption and output$mpgPlot expressions
  #formulaText <- reactive({
 #   paste("mpg ~", input$variable)
 # })
  
  # Return the formula text for printing as a caption
  #output$caption <- renderText({
   # formulaText()
  #})
  
  # Generate a plot of the requested variable against mpg and only 
  # include outliers if requested
  #output$rebounding_plot <- renderPlot({ggplot(a_draft_stats,aes(x=`3pct`,y=`3pm`)) +
   #   geom_point(alpha = .2) +
    #  geom_point(data = filter(a_draft_stats, input$variable == player_name), color="red")},height = 200,width = 300)
  #output$free_throw_plot <- renderPlot({ggplot(a_draft_stats,aes(x=ftpct,y=ftm)) +
    #  geom_point(alpha = .2) +
   #   geom_point(data = filter(a_draft_stats, input$variable == player_name), color="red")},height = 200,width = 300)
  output$mytable = renderDT({
    datatable(filter(a_draft_19_stats_with_percentiles), 
              class = 'cell-border compact hover',
              
              options=list(columnDefs = list(list(visible=FALSE, targets=c(0, 1, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29))))) %>%
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
})

