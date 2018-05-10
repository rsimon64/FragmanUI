
ui_markers <- tabItem(
  tabName = "tabMarkers",
  shiny::fluidRow(
    shinycards::card(width = 3, title = "A\u00F1adir marcador molecular", icon = NULL,
                     shiny::p("Listado actual:"),
                     shiny::textOutput("markerList"),
                     shiny::br(),
                     shiny::textInput("markerName", "Nombre marcador molecular:", placeholder = "nombre"),
                     shiny::textInput("markerID", "ID marcador molecular:", placeholder = "m123"),
                     shiny::textInput("markerDbRef", "Base de datos referencial:", placeholder = "NCBI"),
                     shiny::selectInput("markerVariant", "Tipo de variante:", c("SNP", "SSR", "AFLP", "COS", "Ins/Del"))
    ),
    shinycards::card(width = 3, title = "", icon = NULL,
                     shiny::textInput("markerPriFwd", "Secuencia primer forward:", placeholder = "acgt"),
                     shiny::textInput("markerPriRev", "Secuencia primer reverse:", placeholder = "acgt"),
                     shiny::textInput("markerEnzRes", "Enzima de restriccion:", placeholder = "enzima"),
                     shiny::textAreaInput("markerRef", "Referencia",
                                          placeholder = "Referencia"),
                     shiny::textAreaInput("markerNotes", "Notas",
                                          placeholder = "Notas")
    ),
    shinycards::card(width = 6, title = "", icon = NULL,
                     shiny::selectInput("markerLadder", "Asociar escalera molecular", choices = FragmanUI:::list_ladders()),
                     shiny::sliderInput("markerRange", "Rango bp", 0, 600, c(200, 340) ),
                     shiny::checkboxGroupInput("markerChannels", "Canales preferidos",  1:5,
                                               selected = 1:5, inline = TRUE),
                     shiny::sliderInput("markerThreshold", "Umbral mínimo", 0, 12000, 3000, step = 100),
                     shiny::br(),

                     shiny::actionButton("btnAddMarker", "Crear nuevo marcador")

    )
  )
)


sv_markers <- function(input, output, session) {
  output$markerList <- renderText({
    paste(FragmanUI:::list_markers(), collapse = ", ")
  })

  observeEvent(input$btnAddMarker, {
    marker <- list(x = list(
      markerName = input$markerName,
      markerDbRef = input$markerDbRef,
      markerVariant = input$markerVariant,
      markerPriFwd = input$markerPriFwd,
      markerPriRev = input$markerPriRev,
      markerEnzRes = input$markerEnzRes,
      markerRef = input$markerRef,
      markerNotes = input$markerNotes,
      markerLadder = input$markerLadder,
      markerRange = input$markerRange,
      markerChannels = input$markerChannels,
      markerThreshold = input$markerThreshold
      )
    )
    names(marker)[1] <- input$markerID
    FragmanUI:::add_marker(marker)

    listM <- FragmanUI:::list_markers()

    output$markerList <- renderText({
      paste(listM, collapse = ", ")
    })

    updateSelectInput(session, "importAbiMarker", choices = listM)
    showNotification("Marcador molecular nueva creado!.", type = "message", duration = NULL)
  })

}
