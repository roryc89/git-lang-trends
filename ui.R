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
        start = Sys.Date() - (365 * 3), end = Sys.Date()
      ),

      checkboxGroupInput(
        inputId = "line_types",
        label = "Line types",
        choiceNames = c("All points", "Smoothed"),
        choiceValues = c("all_points", "smoothed"),
        select = c("smoothed")
      ),

      actionButton("top_5", "top 5 languages"),
      actionButton("top_20", "top 20 languages"),
      actionButton("data_science", "data science languages"),
      actionButton("functional", "functional languages"),

      textInput("filter_languages", "", placeholder="Search languages"),

      checkboxGroupInput(
        inputId = "languages",
        label = "Languages",
        choices = all_languages,
        selected = top_5_languages
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "languages",
        fluidRow(
          box(plotlyOutput("lang_ratio_plot", height = 560)),
          box(plotlyOutput("lang_count_plot", height = 560))
        )
      ),
      tabItem(tabName = "widgets",
        h2("Widgets tab content")
      )
    )
  )
)
