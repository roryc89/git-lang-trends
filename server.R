library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(dygraphs)
library(datasets)

function(input, output, session) {

  observe({
    selected_languages <- input$languages
    print("outer input$select_all", input$select_all)

    visible_languages <- all_languages[grep(input$filter_languages, tolower(all_languages))]

    updateCheckboxGroupInput(
      session,
      "languages",
      choices = visible_languages,
      selected = selected_languages)
  })

}
