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
  output$free_throw_plot <- renderPlot({
    
    ggplot(a_draft_stats, aes(`3pct`, `3pa`)) +
      geom_point(color = "#D3D3D3", size = 5, alpha = .5) +
      geom_point(data = filter(a_draft_stats, player_name == player_name_input), color = "red", size = 5)
    
  },height = 200,width = 300)
  
})

