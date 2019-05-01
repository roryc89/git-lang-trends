library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)

function(input, output, session) {

  selected_languages <- reactive({
    selected_languages <- input$languages

    visible_languages <- all_languages[grep(input$filter_languages, tolower(all_languages))]

    updateCheckboxGroupInput(
      session,
      "languages",
      choices = visible_languages,
      selected = selected_languages
    )
    selected_languages
  })

  # output$plot1 <- renderPlot({
  #   print(input)
  #   print(input$date_range)
  #   print(typeof(input$date_range))
  #   print("input$date_range[[1]]")
  #   print(input$date_range[[1]])
  #   print("input$date_range[[2]]")
  #   print(input$date_range[[2]])
  #
  #   date_start = input$date_range[[1]]
  #   date_end = input$date_range[[2]]
  #
  #   repos_in_range = repos[
  #     repos$created_at >= date_start && repos$created_at <= date_start
  #   ]
  #
  #   dist <- rnorm(c(2,3,4,6,7))
  #   hist(repos_in_range)
  # })
  output$plot1 <- renderPlot({
    date_start = ymd(input$date_range[[1]])
    date_end = ymd(input$date_range[[2]])
    print('date_start')
    print(date_start)
    print('date_end')
    print(date_end)
    # print('selected_languages')
    # print(selected_languages)
    repos_in_range = repos_by_month %>%
      # filter(created_at >= date_start && created_at <= date_end) %>%
      filter(language %in% c("C", "Rust", "Python", "R"))

    # df_trend <- ideal[ideal$language == input$name, ]
    # print(repos_in_range)
    ggplot(repos_in_range) +
      geom_line(aes(x = created_at, y = count, color = language), size = 1)
  })

}
