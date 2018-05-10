
ui_about <- tabItem(
  tabName = "tabAbout",
  shiny::fluidRow(
    shinycards::card(width = 6,
                     shiny::HTML(""
                                 #readLines(system.file("doc/tutorial_castellano2.html", package="FragmanUI"))
                     )
    )
  )
)
