
ui_abi <- function() {

  data(liz600)

  ui <- shiny::fluidRow(

    shiny::column(6,
                  shinyFiles::shinyDirButton('btnAbiDir', 'Buscar folder', 'Seleccione un folder',
                                             class = "btn-primary"),

                  shiny::h4("Archivos en el directorio seleccionado"),
                  shiny::verbatimTextOutput("files")
                  ,
                  shiny::checkboxGroupInput("channels", "Canales",  1:5,
                                            selected = 1:5, inline = TRUE),
                  shiny::sliderInput("min_threshold", "Umbral mínimo", 0, 10000, 5000, step = 100),
                  shiny::sliderInput("x_range", "Rango bp", 0, 1000, c(200, 340) )

    ),
    shiny::column(6,
                  shiny::textInput("ladderName", "Nombre de escalera", "liz600"),
                  shiny::textAreaInput("ladderSizes", "Pesos de escalera", paste(liz600, collapse=", "),
                                       rows = 5),
                  shiny::textInput("markerName", "Nombre de marcador", value = "marker"),
                  shiny::numericInput("quality", "Lumbral calidad de genotipo", value = .9999,
                                      min = 0.8, max = 1.0),

                  shiny::fluidRow(
                    shiny::column(6,
                                  #withBusyIndicatorUI(
                                    shiny::actionButton(
                                      "runScoresBtn",
                                      "Procesar archivos",
                                      class = "btn-primary",
                                      icon = shiny::icon("hourglass-start")
                                    )
                                  #)
                                  )
                    ,
                    shiny::column(6 ,
                                  shiny::tags$button(
                                    id = 'close',
                                    type = "button",
                                    class = "btn action-button",
                                    #class = "btn-warning",
                                    onclick = "setTimeout(function(){window.close();}, 10);",  # close browser
                                    "Close window"
                                  )
                    )
                  )



    )

  )

  return(ui)
}
