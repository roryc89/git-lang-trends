library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(plotly)
library(network)
library(sna)
library(GGally)
# install.packages("GGally")


data_science_languages = c(
  "Python", "R", "SQL", "Julia", "Scala", "Matlab", "SAS"
)

functional_languages = c(
  "Clojure", "OCaml", "Haskell", "Scala", "Elixir", "Idris", "Elm", "PureScript"
)


make_repo_node_graph = function(){
  net = rgraph(10, mode = "graph", tprob = 0.5)
  net = network(net, directed = FALSE)

  # vertex names
  network.vertex.names(net) = letters[1:10]
  # ggnet2(net, palette = c("vowel" = "steelblue", "consonant" = "tomato"))
  # ggnet2(net, color = ifelse(net %v% "phono" == "vowel", "steelblue", "tomato"))
  ggnet2(net)
  # ggnet2(net, palette = "Set2")

}


function(input, output, session) {

  observeEvent(input$filter_languages, {
    searched_languages <- all_languages[grep(input$filter_languages, tolower(all_languages))]

    updateCheckboxGroupInput(
      session,
      "languages",
      choices = unique(c(searched_languages, all_languages)),
      selected = input$languages
    )
  })

  observeEvent(input$clear_languages, {
    updateCheckboxGroupInput(
      session,
      "languages",
      choices = all_languages,
      selected = c()
    )
  })

  observeEvent(input$top_5, {
    updateCheckboxGroupInput(
      session,
      "languages",
      choices = all_languages,
      selected = top_5_languages
    )
  })

  observeEvent(input$top_20, {
    updateCheckboxGroupInput(
      session,
      "languages",
      choices = all_languages,
      selected = top_20_languages
    )
  })

  observeEvent(input$data_science, {
    updateCheckboxGroupInput(
      session,
      "languages",
      choices = all_languages,
      selected = data_science_languages
    )
  })

  observeEvent(input$functional, {
    updateCheckboxGroupInput(
      session,
      "languages",
      choices = all_languages,
      selected = functional_languages
    )
  })

  output$lang_ratio_plot <- renderPlotly({
    date_start = ymd(input$date_range[[1]])
    date_end = ymd(input$date_range[[2]])

    filtered_commits = commits_by_date %>%
      filter(date >= date_start & date <= date_end) %>%
      filter(lang %in% input$languages)

    p = ggplot(filtered_commits) +
        expand_limits(y = 0) +
        ylab("language commits / all commits") +
        ggtitle("ratio of commits")


    if("all_points" %in% input$line_types){
      p = p + geom_line(aes(x = date, y = freq, color = lang), size = 0.2)
    }

    if("smoothed" %in% input$line_types){
      p = p + geom_smooth(aes(x = date, y = freq, color = lang), size = 1, method="auto", se=TRUE, fullrange=TRUE, level=0.95)
    }
    p
  })

  output$lang_count_plot <- renderPlotly({
    date_start = ymd(input$date_range[[1]])
    date_end = ymd(input$date_range[[2]])


    filtered_commits = commits_by_date %>%
      filter(date >= date_start & date <= date_end) %>%
      filter(lang %in% input$languages)

    p = ggplot(filtered_commits) +
        expand_limits(y = 0) +
        ylab("Daily commits") +
        ggtitle("Number of commits each day")


    if("all_points" %in% input$line_types){
      p = p + geom_line(aes(x = date, y = n, color = lang), size = 0.2)
    }

    if("smoothed" %in% input$line_types){
      p = p + geom_smooth(aes(x = date, y = n, color = lang), size = 1, method="auto", se=TRUE, fullrange=TRUE, level=0.95)
    }
    p
  })

  output$flights_plot <- renderPlotly({
    make_repo_node_graph()
  })

}
