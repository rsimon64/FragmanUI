
ui_genotypes <- tabItem(
  tabName = "tabGenotypes",
  shiny::fluidRow(
    shinycards::card(width = 6, title = "A\u00F1adir genotypes", icon = NULL,

                     shiny::p("Listado actual:"),
                     shiny::textOutput("genotypesList"),
                     shiny::textInput("genotypesID", "Nombre nuevo grupo genotipos:", placeholder = "listado123"),
                     shiny::textAreaInput("genotypesGroup", "Listado de genotipos separados por comma",
                                          placeholder = "PER123, PER456, ..."),
                     shiny::p("Madre"),
                     shiny::p("Padre"),
                     shiny::actionButton("btnAddGenotypes", "Crear nuevo")
    )
  )
)

sv_genotypes <- function(input, output, session) {

  output$genotypesList <- renderText({
    paste(FragmanUI:::list_genotypes(), collapse = ", ")
  })

  observeEvent(input$btnAddGenotypes, {
    genotypes <- list(x = list(
      genotypesGroup = input$genotypesGroup
    )
    )
    names(genotypes)[1] <- input$genotypesID
    FragmanUI:::add_genotypes(genotypes)

    listG <- FragmanUI:::list_genotypes()

    output$genotypesList <- renderText({
      paste(listG, collapse = ", ")
    })

    updateSelectInput(session, "importAbiGenotypes", choices = listG)
    showNotification("Grupo de genotipos nuevo creado!.", type = "message", duration = NULL)
  })


}
