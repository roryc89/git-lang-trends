library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)

function(input, output, session) {

  selected_languages <- observe({
    selected_languages <- input$languages

    visible_languages <- all_languages[grep(input$filter_languages, tolower(all_languages))]

    updateCheckboxGroupInput(
      session,
      "languages",
      choices = visible_languages,
      selected = selected_languages
    )
  })

  output$lang_count_plot <- renderPlot({
    date_start = ymd(input$date_range[[1]])
    date_end = ymd(input$date_range[[2]])

    repos_in_range = repos_by_month %>%
      filter(created_at >= date_start & created_at <= date_end) %>%
      filter(language %in% input$languages)

    ggplot(repos_in_range) +
      geom_line(aes(x = created_at, y = count, color = language), size = 1)
  })

}
