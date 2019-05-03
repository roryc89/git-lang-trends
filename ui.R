# library(shiny)
library(shinydashboard)


dashboardPage(
  dashboardHeader(title = "Github languages"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Languages", tabName = "languages", icon = icon("language")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th")),

      dateRangeInput(
        'date_range',
        label = 'Choose a date range',
        start = Sys.Date() - (365 * 5), end = Sys.Date() - 60
      ),

      checkboxGroupInput(
        inputId = "line_types",
        label = "Line types",
        choiceNames = c("All points", "Smoothed"),
        choiceValues = c("all_points", "smoothed"),
        select = c("smoothed")
      ),

      actionButton("top_10", "top 10 languages"),
      actionButton("top_25", "top 25 languages"),
      actionButton("data_science", "data science languages"),
      actionButton("functional", "functional languages"),

      textInput("filter_languages", "", placeholder="Search"),

      checkboxGroupInput(
        inputId = "languages",
        label = "Languages",
        choices = all_languages,
        selected = c("Clojure", "Coq", "Haskell", "Julia", "Elixir")
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "languages",
        fluidRow(
          box(plotOutput("lang_ratio_plot", height = 560)),
          box(plotOutput("lang_count_plot", height = 560))
        )
      ),
      tabItem(tabName = "widgets",
        h2("Widgets tab content")
      )
    )
  )
)
