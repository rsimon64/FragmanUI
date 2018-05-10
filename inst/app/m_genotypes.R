
ui_genotypes <- tabItem(
  tabName = "tabGenotypes",
  shiny::fluidRow(
    shinycards::card(width = 6, title = "A\u00F1adir genotypes", icon = NULL,

                     shiny::p("Listado actual:"),
                     shiny::textInput("genotypesID", "Nombre nuevo grupo genotipos:", placeholder = "listado123"),
                     shiny::textAreaInput("genotypesGroup", "Listado de genotipos separados por comma",
                                          placeholder = "PER123, PER456, ..."),
                     shiny::actionButton("btnAddPGenotypes", "Crear nuevo")
    )
  )
)

sv_genotypes <- function(input, output, session) {
  observeEvent(input$btnAddGenotypes, {

    showNotification("Proyecto nuevo creado!.", type = "message", duration = NULL)
  })


}
