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
        start = Sys.Date() - 365, end = Sys.Date()
      ),

      textInput("filter_languages", "", placeholder="Filter"),

      checkboxGroupInput(
        inputId = "languages",
        label = "Languages",
        choices = all_languages,
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
        fluidRow(
          box(plotOutput("plot1", height = 250))

          # box(
          #   title = "Controls",
          #   sliderInput("slider", "Number of observations:", 1, 100, 50)
          # )
        )
      ),
      tabItem(tabName = "widgets",
        h2("Widgets tab content")
      )
    )
  )
)
