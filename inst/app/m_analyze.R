

ui_analyze <- tabItem(
  tabName = "tabAnalyze",
  shiny::fluidRow(
    column(4,

    shinycards::card(title = "Revisar marcador ABI", icon = NULL, width = NULL,
                     #fluidRow(
                       shiny::selectInput("analyzeProject", "Proyecto", FragmanUI:::res_name(FragmanUI:::list_projects() )
                       )
                     #)
                     ,
                     #fluidRow(
                       shiny::uiOutput("analyzeMarkerO")

                     #)
                     ,
                     #fluidRow(
                        br(),
                        br(),
                        div(
                          shiny::actionButton('btnAnalyze', 'Analizar archivos',
                                              class = "btn action-button btn-primary")
                          , style="text-align: center;")

                     #)
                     )
    ),
    column(8,
           fluidRow(
             infoBoxOutput(""),
             infoBoxOutput("")
           ),
           fluidRow(
             infoBoxOutput(""),
             infoBoxOutput("")
           )

    )

  )
)



sv_analyze <- function(input, output, session) {

  output$analyzeMarkerO <- renderUI({
    if(is.null(input$analyzeProject)) return()

    selectInput("analyzeMarker", "Seleccionar marcador", FragmanUI:::res_name(FragmanUI:::list_assays(input$analyzeProject)))

  })

  observeEvent(input$btnReview, {

    v$doPlot <- input$btnAnalyze

    v$prj <- input$analyzeProject
    v$mrk <- input$analyzeMarker

    v$prms <- FragmanUI:::read_scan_params(v$prj, v$mrk)

  })

  v <- reactiveValues(doPlot = FALSE)




  observeEvent(input$analyzeProject, {
    v$doPlot <- FALSE
  })

  observeEvent(input$analyzeMarker, {
    v$doPlot <- FALSE
  })



}
