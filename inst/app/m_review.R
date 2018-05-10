
ui_review <- tabItem(
  tabName = "tabReview",
  shiny::fluidRow(

    shinycards::card(width = 4, title = "Revisar marcador ABI", icon = NULL,
                     fluidRow(
                       column(6,
                              shiny::selectInput("reviewProject", "Proyecto",
                                                 FragmanUI:::res_name(FragmanUI:::list_projects())  )
                       ),
                       column(6,
                              shiny::uiOutput("reviewMarkerO")
                       )
                     ),
                     shiny::wellPanel(
                       fluidRow(
                         column(6,
                                shiny::selectInput("reviewLadder", "Escalera", FragmanUI:::list_ladders()  )
                         ),
                         column(6,
                                shiny::checkboxGroupInput("reviewChannels", "Can\u00E1les preferidos",  1:5,
                                                          selected = 1:5, inline = TRUE)
                         )
                       ),

                       shiny::sliderInput("reviewRange", "Rango bp", 0, 600, c(200, 340) ),

                       shiny::sliderInput("reviewThreshold", "Umbral m\u00EDnimo", 0, 12000, 3000, step = 100),

                       fluidRow(
                         column(6,
                                shiny::numericInput("reviewQuality", "Lumbral calidad de genotipo", value = .9999,
                                                    min = 0.8, max = 1.0)
                         ),
                         column(6,
                                br(),
                                br(),
                                div(
                                  shiny::actionButton('btnReview', 'Actualizar gr\u00E1ficos',
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



sv_review <- function(input, output, session) {

  output$reviewMarkerO <- renderUI({
    if(is.null(input$reviewProject)) return()

    selectInput("reviewMarker", "Seleccionar marcador",
                FragmanUI:::res_name(FragmanUI:::list_assays(input$reviewProject)))

  })

  observeEvent(input$btnReview, {

    v$doPlot <- input$btnReview

    v$prj <- input$reviewProject
    v$mrk <- input$reviewMarker
    v$ldr <- input$reviewLadder
    v$chn <- input$reviewChannels  %>% as.integer
    v$thr <- input$reviewThreshold  %>% as.integer
    v$rng <- input$reviewRange  %>% as.integer
    v$gtt <- input$reviewQuality  %>% as.numeric

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

  })

  v <- reactiveValues(doPlot = FALSE)




  observeEvent(input$reviewProject, {
    v$doPlot <- FALSE
  })

  observeEvent(input$reviewMarker, {
    v$doPlot <- FALSE
  })

  observeEvent(input$reviewLadder, {
    v$doPlot <- FALSE
  })

  observeEvent(input$reviewChannels, {
    v$doPlot <- FALSE
  })

  observeEvent(input$reviewThreshold, {
    v$doPlot <- FALSE
  })

  observeEvent(input$reviewRange, {
    v$doPlot <- FALSE
  })

  observeEvent(input$reviewQuality, {
    v$doPlot <- FALSE
  })



  output$overview2 <- renderPlot({
    if (v$doPlot == FALSE) return()

    isolate({
    withProgress(message = "Actualizando gr\u00E1fico overview", style = "notification", value = 1, {
      score_env <- globalenv()
      folder <- file.path(get_assay_dir(v$prj, v$mrk), "data")
      my_plants <- storing.inds(folder)
      my_ladder <- FragmanUI:::read_ladder(v$ldr)[[1]] %>% as.integer
      ladder.info.attach(stored=my_plants, ladder = my_ladder, env = score_env,  draw = FALSE)
      overview2(my.inds = my_plants, ladder = my_ladder, channel = v$chn, env = score_env)
      abline(h = as.integer(v$thr), col = "red")
      abline(v = as.integer(v$rng), col = "blue")
    })
    })
  }
  )


  output$overview2Zoom <- renderPlot({
    if (v$doPlot == FALSE) return()

    isolate({
    withProgress(message = "Actualizando gr\u00E1fico zoom", style = "notification", value = 1, {
      score_env <- globalenv()
      folder <- file.path(get_assay_dir(v$prj, v$mrk), "data")
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
