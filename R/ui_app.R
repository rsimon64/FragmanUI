ui_app <- shiny::fluidPage(

  shinyjs::useShinyjs(),
  shiny::tags$style(appCSS),
  shiny::titlePanel("ABI scan"),

  shiny::verticalLayout(

    ui_abi()
  )

)
