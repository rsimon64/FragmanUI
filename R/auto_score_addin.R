library(shiny)
library(shinyjs)


auto_score_addin <- function() {


  ui <- miniUI::miniPage(
    useShinyjs(),
    tags$style(appCSS),
  miniUI::gadgetTitleBar("Shiny gadget example"),
  miniUI::miniTabstripPanel(
    miniUI::miniTabPanel("Parameters", icon = shiny::icon("sliders"),
        miniUI::miniContentPanel(
          fluidRow(
            column(6,
            shinyFiles::shinyDirButton ("dir", "Directory of ABI files", "Choose"),
            shiny::checkboxGroupInput("channels", "Channels",  1:5,
                                      selected = 1:5, inline = TRUE),
            shiny::sliderInput("min_threshold", "Minimum threshold", 0, 10000, 5000, step = 100),
            shiny::sliderInput("x_range", "Base pair range", 0, 1000, c(200, 340) )
            ),
            column(6,
            shiny::textInput("ladderName", "Ladder name", "liz600"),
            shiny::textAreaInput("ladderSizes", "Ladder sizes", paste(liz600, collapse=", "),
                                 rows = 5),
            shiny::textInput("markerName", "Marker name", value = "marker"),

            #h4("Files in selected directory"),
            #verbatimTextOutput("files"),

            withBusyIndicatorUI(
              actionButton(
                "runScoresBtn",
                "Process files",
                class = "btn-primary"
              )
            )
            )
          )

        )
    )
   )
  )

  server <- function(input, output, session) {

    shinyFiles::shinyDirChoose(input, 'dir', roots = c(home = '~'), filetypes = c('abi', 'fsa'))
    dir <- shiny::reactive(input$dir)
    output$dir <- shiny::renderPrint(dir())

    # path
    path <- shiny::reactive({
      home <- normalizePath("~")
      file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
    })

    #cat(path())

    # files
    output$files <- renderPrint(list.files(path()))

    observeEvent(input$runScoresBtn, {
      # When the button is clicked, wrap the code in a call to `withBusyIndicatorServer()`
      withBusyIndicatorServer("runScoresBtn", {
        #Sys.sleep(1)
        #print(path())
        df <- FragmanUI::auto_score(path())

      })
    })

    observeEvent(input$done, {
      timeText <- paste0("\"", as.character(Sys.time()), "\"")
      cat(timeText)
      stopApp()
    })
  }

  viewer <- paneViewer(300)
  runGadget(ui, server, viewer = viewer)

}
