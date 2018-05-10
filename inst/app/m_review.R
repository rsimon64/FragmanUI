res_name <- function(x) {
  res_name <- function(x) {
    x <- basename(x)
    stringr::str_split(x, "_")[[1]][3]
  }

  unlist(lapply(x, res_name))
}


ui_review <- tabItem(
  tabName = "tabReview",
  shiny::fluidRow(

    shinycards::card(width = 4, title = "Revisar marcador ABI", icon = NULL,
                     fluidRow(
                       column(6,
                              shiny::selectInput("reviewProject", "Proyecto", res_name(FragmanUI:::list_projects())  )
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

                       shiny::sliderInput("reviewRange", "Rango bp", 0, 1000, c(200, 340) ),

                       shiny::sliderInput("reviewThreshold", "Umbral m\u00EDnimo", 0, 10000, 3000, step = 100)
                     )
                     ,
                     shiny::br(),
                     div(
                       shiny::actionButton('btnReview', 'Actualizar gr\u00E1ficos')
                       , style="text-align: center;")

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

    selectInput("reviewMarker", "Seleccionar marcador", res_name(FragmanUI:::list_assays(input$reviewProject)))

  })

  observeEvent(input$btnReview, {

    v$doPlot <- input$btnReview

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



  output$overview2 <- renderPlot({
    # A temp file to save the output. It will be deleted after renderImage
    # sends it, because deleteFile=TRUE.
    if (v$doPlot == FALSE) return()

    isolate({
    withProgress(message = "Actualizando gr\u00E1fico overview", style = "notification", value = 1, {

      # outfile <- tempfile(fileext='.png')
      # png(outfile, width = 1000, height = 400, units = "px" )
      prj <- input$reviewProject
      mrk <- input$reviewMarker
      ldr <- input$reviewLadder
      chn <- input$reviewChannels  %>% as.integer
      thr <- input$reviewThreshold  %>% as.integer
      rng <- input$reviewRange  %>% as.integer

      score_env <- globalenv()

      folder <- file.path(get_assay_dir(prj, mrk), "data")


      my_plants <- storing.inds(folder)
      my_ladder <- FragmanUI:::read_ladder(ldr)[[1]] %>% as.integer
      ladder.info.attach(stored=my_plants, ladder = my_ladder, env = score_env,  draw = FALSE)
      overview2(my.inds = my_plants, ladder = my_ladder, channel = chn, env = score_env)
      abline(h = as.integer(thr), col = "red")
      abline(v = as.integer(rng), col = "blue")

      #dev.off()
    })
    })
    # Return a list
    # list(src = outfile,
    #      alt = "This is alternate text")
  }#, deleteFile = TRUE
  )





  output$overview2Zoom <- renderPlot({
    # A temp file to save the output. It will be deleted after renderImage
    # sends it, because deleteFile=TRUE.
    if (v$doPlot == FALSE) return()

    isolate({
    withProgress(message = "Actualizando gr\u00E1fico zoom", style = "notification", value = 1, {

      # outfile <- tempfile(fileext='.png')
      # png(outfile, width = 1000, height = 400, units = "px" )
      prj <- input$reviewProject
      mrk <- input$reviewMarker
      ldr <- input$reviewLadder
      chn <- input$reviewChannels  %>% as.integer
      thr <- input$reviewThreshold  %>% as.integer
      rng <- input$reviewRange  %>% as.integer

      score_env <- globalenv()


      folder <- file.path(get_assay_dir(prj, mrk), "data")
      my_plants <- storing.inds(folder)
      my_ladder <- FragmanUI:::read_ladder(ldr)[[1]] %>% as.integer
      ladder.info.attach(stored=my_plants, ladder = my_ladder, env = score_env,  draw = FALSE)
      overview2(my.inds = my_plants, ladder = my_ladder, channel = chn, env = score_env,
                xlim = rng)
      abline(h = as.integer(thr), col = "red")
      abline(v = as.integer(rng), col = "blue")

      #dev.off()
    })
    })
    # Return a list
    # list(src = outfile,
    #      alt = "This is alternate text")
  }#, deleteFile = TRUE
  )





}
