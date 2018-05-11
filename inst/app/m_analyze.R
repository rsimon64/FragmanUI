

ui_analyze <- tabItem(
  tabName = "tabAnalyze",
  shiny::fluidRow(
    column(4,

    shinycards::card(title = "Revisar marcador ABI", icon = NULL, width = NULL,
                       shiny::selectInput("analyzeProject", "Proyecto", FragmanUI:::res_name(FragmanUI:::list_projects() )
                       )
                     ,
                       shiny::uiOutput("analyzeMarkerO")
                     ,
                        br(),
                        br(),
                        div(
                          shinyjs::hidden(p(id = "anaHint", "Favor revisar parametros antes de analizar.")),
                          shiny::actionButton('btnAnalyze', 'Analizar archivos',
                                              class = "btn action-button btn-primary")
                          , style="text-align: center;")
                     )
    ),
    column(8,
           fluidRow(
             infoBoxOutput("anaOLadder"),
             infoBoxOutput("anaOThreshold")
           ),
           fluidRow(
             infoBoxOutput("anaORange"),
             infoBoxOutput("anaOQuality")
           ),
           fluidRow(
             infoBoxOutput("anaOChannels")
           )

    )

  )
)



sv_analyze <- function(input, output, session) {

  output$analyzeMarkerO <- renderUI({
    if(is.null(input$analyzeProject)) return()

    selectInput("analyzeMarker", "Seleccionar marcador", FragmanUI:::res_name(FragmanUI:::list_assays(input$analyzeProject)))

  })

  vAna <- reactiveValues(doAnalysis = FALSE)

  updateAnalyzeUI <- function() {
    vAna$prj <- input$analyzeProject
    vAna$mrk <- input$analyzeMarker

    vAna$prms <- FragmanUI:::read_scan_params(vAna$prj, vAna$mrk)

    #message(str(vAna$prms$channels))

    if(is.null(vAna$prms)) {
      shinyjs::hide("btnAnalyze")
      shinyjs::show("anaHint")
    } else {
      shinyjs::show("btnAnalyze")
      shinyjs::hide("anaHint")
    }
  }


  observeEvent(input$analyzeMarker, {
    updateAnalyzeUI()
  })

  observeEvent(input$analyzeProject, {
    if(is.null(input$analyzeMarker)) return()
    updateAnalyzeUI()
  })

  observeEvent(input$btnAnalyze, {

    vAna$doAnalysis <- input$btnAnalyze
    shiny::withProgress(message = 'Procesando ...', style = "notification", value = 1, {
      ladder <- FragmanUI:::read_ladder(vAna$prms$ladder_ID)[[1]]

      pn <- vAna$prms$project_ID
      mn <- vAna$prms$marker_ID
      fp <- file.path(FragmanUI:::get_assay_dir(pn, mn), "data")
      ch <- vAna$prms$channels %>% as.integer()
      mt <- vAna$prms$threshold %>% as.integer()
      xr <- vAna$prms$range_bp  %>% as.integer()
      gq <- vAna$prms$genotype_Q  %>% as.numeric()

      df <- FragmanUI::auto_score(
        folder <- fp,
        channels = ch,
        min_threshold = mt,
        x_range = xr,
        marker = mn,
        myladder = ladder,
        quality = gq
      )

      dr <- FragmanUI:::get_assay_dir(pn, mn)
      rn <- file.path(dr, "results")
      fp <- file.path(rn, "scores.csv")
      utils::write.csv(df, file = fp, row.names = FALSE)
      fb <- file.path(rn, "scores_bin.csv")
      fb <- stringr::str_replace_all(fb, "\\\\", "/")
      score_bin <- FragmanUI:::convert_to_binary(scores = df)
      utils::write.csv(score_bin, file = fb)

      bad_samples <- attr(df, "bad_samples")
      #
      fs <- file.path(rn, "samples_low_quality.csv")
      fs <- stringr::str_replace_all(fs, "\\\\", "/")
      utils::write.csv(bad_samples, fs)


    })

    showNotification("Archivos analizados!", type = "message", duration = NULL)


  })






  observeEvent(input$analyzeProject, {
    vAna$doAnalysis <- FALSE
  })

  observeEvent(input$analyzeMarker, {
    vAna$doAnalysis <- FALSE
  })

  output$anaOLadder <- renderInfoBox({
    infoBox("Escalera Molecular", vAna$prms$ladder_ID)
  })

  output$anaOThreshold <- renderInfoBox({
    infoBox("Umbral minimo", vAna$prms$threshold)
  })

  output$anaORange <- renderInfoBox({
    infoBox("Rango pares de bases",
            paste(vAna$prms$range_bp[1], " - ", vAna$prms$range_bp[2]))
  })

  output$anaOQuality <- renderInfoBox({
    infoBox("Calidad minimo de genotipo", vAna$prms$genotype_Q)
  })

  output$anaOChannels <- renderInfoBox({
    infoBox("Canales", paste(vAna$prms$channels, collapse = ", "))
  })

}
