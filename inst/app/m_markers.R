
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
                     shiny::sliderInput("markerRange", "Rango bp", 0, 1000, c(200, 340) ),
                     shiny::checkboxGroupInput("channels", "Canales preferidos",  1:5,
                                               selected = 1:5, inline = TRUE),
                     shiny::sliderInput("markerThreshold", "Umbral mínimo", 0, 10000, 3000, step = 100),
                     shiny::br(),

                     shiny::actionButton("btnAddMarker", "Crear nuevo marcador")

    )
  )
)
