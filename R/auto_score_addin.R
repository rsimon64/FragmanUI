
auto_score_addin <- function() {

  ui <- miniUI::miniPage(
    shinyjs::useShinyjs(),
    shiny::tags$style(appCSS),
    miniUI::gadgetTitleBar("ABI Escoreo en Lote"),

    miniUI::miniTabstripPanel(id = "inScores",
      miniUI::miniTabPanel("Parametros", id = "params", icon = shiny::icon("sliders"),
        miniUI::miniContentPanel(
          ui_abi()
        )
      )
    )
  )

  server <- function(input, output, session) {
    path <- sv_abi(input, output, session)


    shiny::observeEvent(input$done, {
      # sv_abi_rstudio(path)

      shiny::stopApp()
    })


  }

  viewer <- shiny::browserViewer()
  #shiny::runGadget(ui, server, viewer = viewer)
  shiny::shinyApp(ui, server, options = list(
    port = 9876,
    launch.browser = TRUE
  ))

}
