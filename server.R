library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)

function(input, output, session) {

  observe({
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


    filtered_commits = commits_by_date %>%
      filter(date >= date_start & date <= date_end) %>%
      filter(lang %in% input$languages)

    ggplot(filtered_commits) +
      geom_line(aes(x = date, y = n, color = lang), size = 0.2) +
        geom_smooth(aes(x = date, y = n, color = lang), size = 1, method="auto", se=TRUE, fullrange=TRUE, level=0.95) +
        expand_limits(y = 0)
  })

}
