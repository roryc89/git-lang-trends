# library(shiny)
library(shinydashboard)


dashboardPage(
  dashboardHeader(title = "Github languages"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th")),
      sidebarSearchForm("filter_languages", buttonId = "searchButton",
                  label = "Search..."),

      # textInput("filter_languages", "", placeholder="Filter languages"),

      checkboxGroupInput(inputId = "languages",
                     label = "Languages",
                     choices = all_languages,
                   )
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
        fluidRow(
          box(plotOutput("plot1", height = 250)),

          box(
            title = "Controls",
            sliderInput("slider", "Number of observations:", 1, 100, 50)
          )
        )
      ),
      tabItem(tabName = "widgets",
        h2("Widgets tab content")
      )
    )
  )
)
# library(dygraphs)
#
#
# fluidPage(
#   titlePanel("Github languages"),
#   sidebarLayout(
#     sidebarPanel(
#
#       textInput("filter_languages", "", placeholder="Filter"),
#
#       checkboxGroupInput(inputId = "languages",
#                      label = "Languages",
#                      choices = all_languages
#                    )
#
#     ),
#     mainPanel(
#       fluidRow(
#         dygraphOutput("dygraph")
#       )
#     )
#   )
# )
