
ui_ladders <- tabItem(
  tabName = "tabLadders",
  shiny::fluidRow(
    shinycards::card(width = 6, title = "A\u00F1adir escalera molecular", icon = NULL,
                     shiny::p("Listado actual:"),
                     shiny::textOutput("ladderList"),
                     shiny::br(),
                     shiny::textInput("ladderID", "Nombre nueva escalera molecular:", placeholder = "nombre900"),
                     shiny::textAreaInput("ladderBp", "Listado de pesos moleculares separados por comma",
                                          placeholder = "30, 60, 90, ..."),
                     shiny::actionButton("btnAddLadderID", "Crear nueva")

    )
  )
)


sv_ladders <- function(input, output, session) {
  output$ladderList <- renderText({
    paste(FragmanUI:::list_ladders(), collapse = ", ")
  })

  observeEvent(input$btnAddLadderID, {
    ladder <- list(input$ladderBp  %>% stringr::str_split(", ") %>% unlist %>% as.integer )
    names(ladder)[1] <- input$ladderID
    FragmanUI:::add_ladder(ladder)

    listL <- FragmanUI:::list_ladders()

    output$ladderList <- renderText({
      paste(listL, collapse = ", ")
    })

    updateSelectInput(session, "markerLadder", choices = listL)
    updateSelectInput(session, "importAbiLadder", choices = listL)
    updateSelectInput(session, "evaluateLadder", choices = listL)

    showNotification("Escalera mmolecular nueva creado!.", type = "message", duration = NULL)
  })

}
