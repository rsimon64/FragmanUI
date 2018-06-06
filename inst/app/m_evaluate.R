
ui_evaluate <- tabItem(
  tabName = "tabEvaluate",
  shiny::fluidRow(

    shinycards::card(width = 4, title = "Evaluar marcador ABI", icon = NULL,
                     fluidRow(
                       column(6,
                              shiny::selectInput("evaluateProject", "Proyecto",
                                                 FragmanUI:::res_name(FragmanUI:::list_projects())  )
                       ),
                       column(6,
                              shiny::uiOutput("evaluateMarkerO")
                       )
                     ),
                     # TODO insert radiobuttons to switch beween preloading: system default, marker standard, or last modification
                     # TODO if no saved params are found: use the marker default to create an archive!
                     # TODO new option: set ploidy level! should be done in genotype module! Additional option: just read all peaks
                     # TODO modify algorithm to select all peaks above threshold!
                     shiny::wellPanel(
                       fluidRow(
                         column(6,
                                shiny::selectInput("evaluateLadder", "Escalera", FragmanUI:::list_ladders()  )
                         ),
                         column(6,
                                shiny::checkboxGroupInput("evaluateChannels", "Can\u00E1les preferidos",  1:5,
                                                          selected = 1:5, inline = TRUE)
                         )
                       ),

                       shiny::sliderInput("evaluateRange", "Rango bp", 0, 600, c(200, 340) ),

                       shiny::sliderInput("evaluateThreshold", "Umbral m\u00EDnimo", 0, 12000, 3000, step = 100),

                       fluidRow(
                         column(6,
                                shiny::numericInput("evaluateQuality", "Lumbral calidad de genotipo", value = .9999,
                                                    min = 0.8, max = 1.0)
                         ),
                         column(6,
                                br(),
                                br(),
                                div(
                                  shiny::actionButton('btnEvaluate', 'Actualizar gr\u00E1ficos',
                                                      class = "btn action-button btn-primary")
                                  , style="text-align: center;")

                         )
                       )
                     )


    ),
    shinycards::card(width = 8, title = "Gr\u00E1ficos", icon = NULL,
                     shiny::h3("Overview"),
                     shiny::wellPanel(
                       shiny::plotOutput("overview2")
                     ),
                     shiny::h3("Zoom in"),
                     shiny::wellPanel(
                       shiny::plotOutput("overview2Zoom")
                     )


    )
  )
)



sv_evaluate <- function(input, output, session) {

  output$evaluateMarkerO <- renderUI({
    if(is.null(input$evaluateProject)) return()

    selectInput("evaluateMarker", "Seleccionar marcador",
                FragmanUI:::res_name(FragmanUI:::list_assays(input$evaluateProject)))

  })

  observeEvent(input$btnEvaluate, {

    v$doPlot <- input$btnEvaluate

    v$prj <- input$evaluateProject
    v$mrk <- input$evaluateMarker
    v$ldr <- input$evaluateLadder
    v$chn <- input$evaluateChannels  %>% as.integer
    v$thr <- input$evaluateThreshold  %>% as.integer
    v$rng <- input$evaluateRange  %>% as.integer
    v$gtt <- input$evaluateQuality  %>% as.numeric

    # save selected parameter values to corresponding assay!
    # will be read for extracting scores from all archives
    prms <- list(
      project_ID = v$prj,
      marker_ID = v$mrk,
      ladder_ID = v$ldr,
      channels = v$chn,
      threshold = v$thr,
      range_bp = v$rng,
      genotype_Q = v$gtt
    )

    FragmanUI:::save_scan_params(prms, v$prj, v$mrk)
    # note <- notificationItem("Paramétros guardados!", icon = icon("info"), status = "success",
    #                  href = NULL)

    now <- Sys.time()
    id <- paste0("RevPar", now)

    notifications[[id]] <- list(
      id = "id",
      icon = "info",
      status = "success",
      href = NULL,
      text = paste("evaluate parametros guardados!")
    )

    updateSelectInput(session, input$analyzeProject, selected = v$prj)

  })

  v <- reactiveValues(doPlot = FALSE)




  observeEvent(input$evaluateProject, {
    v$doPlot <- FALSE
  })

  observeEvent(input$evaluateMarker, {
    v$doPlot <- FALSE
  })

  observeEvent(input$evaluateLadder, {
    v$doPlot <- FALSE
  })

  observeEvent(input$evaluateChannels, {
    v$doPlot <- FALSE
  })

  observeEvent(input$evaluateThreshold, {
    v$doPlot <- FALSE
  })

  observeEvent(input$evaluateRange, {
    v$doPlot <- FALSE
  })

  observeEvent(input$evaluateQuality, {
    v$doPlot <- FALSE
  })



  output$overview2 <- renderPlot({
    if (v$doPlot == FALSE) return()

    #isolate({
    score_env <- globalenv()
    folder <- file.path(FragmanUI:::get_assay_dir(v$prj, v$mrk), "data")
    my_plants <- storing.inds(folder)
    my_ladder <- FragmanUI:::read_ladder(v$ldr)[[1]] %>% as.integer

    do_calc <- function() {
    #withProgress(message = "Actualizando gr\u00E1fico overview", style = "notification", value = 1, {

      ladder.info.attach(stored=my_plants, ladder = my_ladder, env = score_env,  draw = FALSE)

    #}
    }

    #future(do_calc) %...>% {
    do_calc()
      overview2(my.inds = my_plants, ladder = my_ladder, channel = v$chn, env = score_env)
      abline(h = as.integer(v$thr), col = "red")
      abline(v = as.integer(v$rng), col = "blue")
    #}

    #})
  }
  )


  output$overview2Zoom <- renderPlot({
    if (v$doPlot == FALSE) return()

    isolate({
    withProgress(message = "Actualizando gr\u00E1fico zoom", style = "notification", value = 1, {
      score_env <- globalenv()
      folder <- file.path(FragmanUI:::get_assay_dir(v$prj, v$mrk), "data")
      my_plants <- storing.inds(folder)
      my_ladder <- FragmanUI:::read_ladder(v$ldr)[[1]] %>% as.integer
      ladder.info.attach(stored=my_plants, ladder = my_ladder, env = score_env,  draw = FALSE)
      overview2(my.inds = my_plants, ladder = my_ladder, channel = v$chn, env = score_env,
                xlim = v$rng)
      abline(h = as.integer(v$thr), col = "red")
      abline(v = as.integer(v$rng), col = "blue")
    })
    })
  }
  )

}
