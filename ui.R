library(shiny)
library(dygraphs)



fluidPage(
  titlePanel("Github languages"),
  sidebarLayout(
    sidebarPanel(

      textInput("filter_languages", "", placeholder="Filter"),

      checkboxGroupInput(inputId = "languages",
                     label = "Languages",
                     choices = all_languages
                   )

    ),
    mainPanel(
      fluidRow(
        dygraphOutput("dygraph")
      )
    )
  )
)
