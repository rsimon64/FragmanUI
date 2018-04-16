# library(shiny)
# library(shinyjs)
# library(DT)


auto_score_addin <- function() {


  ui <- miniUI::miniPage(
    shinyjs::useShinyjs(),
    shiny::tags$style(appCSS),
  miniUI::gadgetTitleBar("ABI Escoreo en Lote"),
  miniUI::miniTabstripPanel(id = "inScores",
    miniUI::miniTabPanel("Parametros", id = "params", icon = shiny::icon("sliders"),
        miniUI::miniContentPanel(
          shiny::fluidRow(
            shiny::column(6,
            shinyFiles::shinyDirButton ("dir", "Seleccionar directorio ABI", "Seleccionar",
                                        buttonType = "primary"),
            shiny::checkboxGroupInput("channels", "Canales",  1:5,
                                      selected = 1:5, inline = TRUE),
            shiny::sliderInput("min_threshold", "Umbral mínimo", 0, 10000, 5000, step = 100),
            shiny::sliderInput("x_range", "Rango bp", 0, 1000, c(200, 340) ),
            shiny::h4("Archivos en el directorio seleccionado"),
            shiny::verbatimTextOutput("files")

            ),
            shiny::column(6,
            shiny::textInput("ladderName", "Nombre de escalera", "liz600"),
            shiny::textAreaInput("ladderSizes", "Pesos de escalera", paste(liz600, collapse=", "),
                                 rows = 5),
            shiny::textInput("markerName", "Nombre de marcador", value = "marker"),
            shiny::numericInput("quality", "Lumbral calidad de genotipo", value = .9999,
                                min = 0.8, max = 1.0),


            withBusyIndicatorUI(
              shiny::actionButton(
                "runScoresBtn",
                "Procesar archivos",
                class = "btn-primary"
              )
            )

            )


          )

        )
        ),
        miniUI::miniTabPanel("Resultados", id ="results", icon = shiny::icon("table"),
            miniUI::miniContentPanel(
              DT::DTOutput("scoreResults", height = "600px")
            )
        )

   )
  )

  server <- function(input, output, session) {



    shinyFiles::shinyDirChoose(input, 'dir', roots = c(home = '~'), filetypes = c('abi', 'fsa'))
    dir <- shiny::reactive(input$dir)
    output$dir <- shiny::renderPrint(dir())

    old_path <- shiny::reactive({
      getwd()
    })

    # path
    path <- shiny::reactive({
      home <- normalizePath("~")

      file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
    })

    #cat(path())

    # files
    output$files <- shiny::renderPrint(list.files(path()))

    #df <- NULL

    shiny::observeEvent(input$runScoresBtn, {
      # When the button is clicked, wrap the code in a call to `withBusyIndicatorServer()`
      withBusyIndicatorServer("runScoresBtn", {
        #Sys.sleep(1)
        #print(path())

        ladder <- stringr::str_split(input$ladderSizes, ", ")[[1]] %>% as.integer
        # message(paste(
        #   ladder,
        #   input$channels,
        #   input$x_range
        # ))

        df <- FragmanUI::auto_score(
          folder = path(),
          channels = input$channels %>% as.integer,
          min_threshold = input$min_threshold %>% as.integer,
          x_range = input$x_range %>% as.integer,
          marker = input$markerName,
          myladder = ladder,
          quality = input$quality %>% as.numeric
        )

        #message(path())
        bn <- basename(path())
        #message(bn)
        rn <- stringr::str_sub(path(), 1, nchar(path()) - nchar(bn))
        rn <- paste0(rn, "results")
        #message(rn)

        if(!dir.exists(rn)) dir.create(rn)

        fp <- file.path(rn, "scores.csv")

        utils::write.csv(df, file = fp)
        bad_samples <- attr(df, "bad_samples")

        fs <- file.path(rn, "samples_low_quality.csv")
        fs <- stringr::str_replace_all(fs, "\\\\", "/")
        utils::write.csv(bad_samples, fs)


        output$scoreResults <- DT::renderDataTable(df)

        params <- list(
          folder = path(),
          channels = input$channels,
          min_threshold = input$min_threshold,
          x_range = input$x_range,
          marker = input$markerName,
          ladder = list(
                      name = input$ladderName,
                      sizes = input$ladderSizes
                   ),
          quality_threshold = input$quality
        )
        #names(params)[length(params)] <- input$ladderName
        #
        params <- yaml::as.yaml(params)
        yaml::write_yaml(params, file.path(rn, "params.yaml.txt"))


        scores <- df
        fp <- stringr::str_replace_all(fp, "\\\\", "/")
        rstudioapi::sendToConsole(paste0("scores <- read.csv('",fp,"')"), execute = TRUE)
        rstudioapi::sendToConsole(paste0("samples_low_quality <- read.csv('",fs,"')"), execute = TRUE)

        msg <- paste("Resultados grabados en", fp)
        message(msg)
        shiny::showNotification(msg, type = "message")

        message("Genotipos de baja calidad son:")
        message(paste(names(attr(df, "bad_samples")), collapse = ", "))

     })
    })

    shiny::observeEvent(input$done, {

      message("Escoreos are dispopnibles en la variable 'scores'.")


      shiny::stopApp()
    })
  }

  viewer <- shiny::paneViewer(500)
  shiny::runGadget(ui, server, viewer = viewer)

}
