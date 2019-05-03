# library(shiny)
library(shinydashboard)


dashboardPage(
  dashboardHeader(title = "Github languages"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th")),

      dateRangeInput(
        'date_range',
        label = 'Choose a date range',
        start = Sys.Date() - (365 * 8), end = Sys.Date()
      ),

      checkboxGroupInput(
        inputId = "line_types",
        label = "Line types",
        choiceNames = c("All points", "Smoothed"),
        choiceValues = c("all_points", "smoothed"),
        select = c("smoothed")
      ),

      textInput("filter_languages", "", placeholder="Filter"),

      checkboxGroupInput(
        inputId = "languages",
        label = "Languages",
        choices = all_languages,
        selected = c("Python", "Java", "JavaScript", "C")
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
        fluidRow(
          box(plotOutput("lang_count_plot", height = 560))
        )
      ),
      tabItem(tabName = "widgets",
        h2("Widgets tab content")
      )
    )
  )
)
