
run_fran <- function(ui = FragmanUI:::ui_app, sv = FragmanUI:::sv_app, port = 9876, browser = TRUE) {

  shiny::shinyApp(
    ui = ui,
    server = sv,
    options = list(
      port = port,
      launch.browser = browser
    )
  )
}
