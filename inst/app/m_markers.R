
ui_markers <- tabItem(
  tabName = "tabMarkers",
  shiny::fluidRow(
    shinycards::card(width = 6, title = "A\u00F1adir marcador molecular", icon = NULL,
                     shiny::p("Listado actual:"),
                     shiny::textOutput("markerList"),
                     shiny::br(),
                     shiny::textInput("markerID", "Nombre nuevo marcador molecular:", placeholder = "m123"),
                     shiny::p("Base de datos referential"),
                     shiny::p("Tipo de variante"),
                     shiny::p("secuencia primer forward"),
                     shiny::p("secuencia primer reverse"),
                     shiny::textAreaInput("markerNotes", "Referencia y notas",
                                          placeholder = "Referencia y notas")
    ),
    shinycards::card(width = 6, title = "", icon = NULL,
                     #shiny::p("ladder"),
                     shiny::selectInput("markerLadder", "Asociar escalera molecular", choices = FragmanUI:::list_ladders()),
                     #shiny::p("bp range"),
                     shiny::sliderInput("markerRange", "Rango bp", 0, 1000, c(200, 340) ),
                     #shiny::p("channels"),
                     shiny::checkboxGroupInput("channels", "Canales preferidos",  1:5,
                                               selected = 1:5, inline = TRUE),
                     #shiny::p("lumbral"),
                     shiny::sliderInput("markerThreshold", "Umbral mínimo", 0, 10000, 3000, step = 100),
                     shiny::br(),

                     shiny::actionButton("btnAddMarker", "Crear nuevo marcador")

    )
  )
)
