
sv_app <- function(input, output, session) {
  path <- sv_abi(input, output, session)

  session$onSessionEnded(function() {
    shiny::stopApp()
  })

  shiny::observe({
    if (input$close > 0){
      shiny::stopApp()
    }
  })

}
