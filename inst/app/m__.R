library(shinyware)
library(shiny)
library(shinydashboard)
library(Fragman)


sv_std <- function(input, output, session) {

  session$onSessionEnded(function() {
    shiny::stopApp()
  })


#
#   tasks <-  reactiveValues(
#     help = list(id = "help", value = 100, color = "aqua",
#                 text = "Familiarizarse con el programa.")
#     # ,
#     # layout = list(id = "layout", value = 40, color = "green",
#     #               text = "Design new layout"),
#     # docs = list(id = "docs", value = 25, color = "red",
#     #             text = "Write documentation")
#
#   )
#
#
#   output$taskMenu <- renderMenu({
#     items <- lapply(tasks, function(el) {
#       taskItem(value = el$value, color = el$color, text = el$text)
#     })
#     dropdownMenu(
#       type = "tasks", badgeStatus = "danger",
#       .list = items
#     )
#   })
#


  output$notificationMenu <- renderMenu({
    items <- lapply(reactiveValuesToList(notifications), function(el) {
      notificationItem(status = el$status, icon = el$icon, text = el$text,
                       href = el$href)
    })
    dropdownMenu(
      type = "notifications", badgeStatus = "info",
      .list = items
    )
  })






}





