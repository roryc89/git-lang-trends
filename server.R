library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(plotly)

data_science_languages = c(
  "Python", "R", "SQL", "Julia", "Scala", "Matlab", "SAS"
)

functional_languages = c(
  "Clojure", "OCaml", "Haskell", "Scala", "Elixir", "Idris", "Elm", "PureScript"
)


df_edges <- flights %>% group_by(origin, dest) %>% summarize(weight = n())
df_edges %>% arrange(desc(weight)) %>% head()


colors = c("#9998db", "#e74c3c", "#2ecc71")
# seting alphabetical order; allows for predictable ordering later
origins = c("EWR", "JFK", "LGA")
df_colors = tbl_df(data.frame(origin=origins, color=origins))
df_edges <- df_edges %>% left_join(df_colors)


net <- graph.data.frame(df_edges, directed = T)


V(net)$degree <- centralization.degree(net)$res
V(net)$weighted_degree <- graph.strength(net)
V(net)$color_v <- c(origins, rep("Others", gorder(net) - length(colors)))


df_airports <- data.frame(vname=V(net)$name) %>% left_join(airports, by=c("vname" = "faa"))


V(net)$text <- paste(V(net)$name,
                       df_airports$name,
                       paste(format(V(net)$weighted_degree, big.mark=",", trim=T), "Flights"),
                        sep = "<br>")
V(net)$text %>% head()


V(net)$lat <- df_airports$lat
V(net)$lon <- df_airports$lon


# gives to/from locations; map to corresponding ending lat/long
end_loc <- data.frame(ename=get.edgelist(net)[,2]) %>% left_join(airports, by=c("ename" = "faa"))


set.seed(123)
df_net <- ggnetwork(net, layout = "fruchtermanreingold", weights="weight", niter=50000, arrow.gap=0)
df_net %>% head()


flights_plot <- ggplot(df_net, aes(x = x, y = y, xend = xend, yend = yend)) +
    geom_edges(aes(color = color), size=0.4, alpha=0.25) +
    geom_nodes(aes(color = color_v, size = degree, text=text)) +
    ggtitle("Network Graph of U.S. Flights Outbound from NYC in 2013") +
    scale_color_manual(labels=c("EWR", "JFK", "LGA", "Others"),
                         values=c(colors, "#1a1a1a"), name="Airports") +
    guides(size=FALSE) +
    # theme_blank() +
    theme(plot.title = element_text(family="Source Sans Pro"),
            legend.title = element_text(family="Source Sans Pro"),
            legend.text = element_text(family="Source Sans Pro"))

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
        ylab("language daily commits / all daily commits") +
        ggtitle("Ratio of commits each day")


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
    flights_plot
  })

}
