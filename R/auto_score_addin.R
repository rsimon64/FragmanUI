library(shiny)
library(shinyjs)
library(DT)


auto_score_addin <- function() {


  ui <- miniUI::miniPage(
    shinyjs::useShinyjs(),
    tags$style(appCSS),
  miniUI::gadgetTitleBar("ABI Auto Score Tool"),
  miniUI::miniTabstripPanel(id = "inScores",
    miniUI::miniTabPanel("Parameters", id = "params", icon = shiny::icon("sliders"),
        miniUI::miniContentPanel(
          fluidRow(
            column(6,
            shinyFiles::shinyDirButton ("dir", "Directory of ABI files", "Choose"),
            shiny::checkboxGroupInput("channels", "Channels",  1:5,
                                      selected = 1:5, inline = TRUE),
            shiny::sliderInput("min_threshold", "Minimum threshold", 0, 10000, 5000, step = 100),
            shiny::sliderInput("x_range", "Base pair range", 0, 1000, c(200, 340) ),
            h4("Files in selected directory"),
            verbatimTextOutput("files")

            ),
            column(6,
            shiny::textInput("ladderName", "Ladder name", "liz600"),
            shiny::textAreaInput("ladderSizes", "Ladder sizes", paste(liz600, collapse=", "),
                                 rows = 5),
            shiny::textInput("markerName", "Marker name", value = "marker"),


            withBusyIndicatorUI(
              actionButton(
                "runScoresBtn",
                "Process files",
                class = "btn-primary"
              )
            )

            # actionButton(
            #   "runScoresBtn",
            #
            #   "Score!",
            #   class = "btn-primary"
            #
            # ),
            #
            #
            # conditionalPanel(condition = 'input.runScoresBtn > 0', id="ncheckSign",
            #                    style="display: inline-block;",
            #                    #shinycssloaders::withSpinner(
            #                      shiny::icon("check")
            #                    #   , type = 3, size = .2,
            #                    #   color.background = "white"
            #                    # )
            # )




            )



          )

        )
        ),
        miniUI::miniTabPanel("Results", id ="results", icon = shiny::icon("table"),
            miniUI::miniContentPanel(
              DTOutput("scoreResults", height = "600px")
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
    output$files <- renderPrint(list.files(path()))

    #df <- NULL

    observeEvent(input$runScoresBtn, {
      # When the button is clicked, wrap the code in a call to `withBusyIndicatorServer()`
      withBusyIndicatorServer("runScoresBtn", {
        #Sys.sleep(1)
        #print(path())
        df <- FragmanUI::auto_score(path())

        #message(path())
        bn <- basename(path())
        #message(bn)
        rn <- stringr::str_sub(path(), 1, nchar(path()) - nchar(bn))
        rn <- paste0(rn, "results")
        #message(rn)

        if(!dir.exists(rn)) dir.create(rn)

        fp <- file.path(rn, "scores.csv")

        write.csv(df, file = fp)
        output$scoreResults <- DT::renderDataTable(df)

        updateTabsetPanel (session, "inScores",
                          selected = "results")


        scores <<- df

        msg <- paste("Results written to", fp)
        message(msg)
        shiny::showNotification(msg, type = "message")

        message("Genotypes with a low overall quality score are:")
        message(paste(names(attr(df, "bad_samples")), collapse = ", "))

     })
    })

    observeEvent(input$done, {

      message("Resulting scores are also available in the variables 'scores'.")


      stopApp()
    })
  }

  viewer <- paneViewer(500)
  runGadget(ui, server, viewer = viewer)

}
