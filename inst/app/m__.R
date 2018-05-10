library(shinyware)
library(shiny)
library(shinydashboard)


sv_std <- function(input, output, session) {
  output$notificationMenu <- shinydashboard::renderMenu({
    shinydashboard::dropdownMenu(type = "notifications",
                                 badgeStatus = NULL
    )
  })


  session$onSessionEnded(function() {
    shiny::stopApp()
  })

}
