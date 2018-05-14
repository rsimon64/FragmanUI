

ui_review <- tabItem(
  tabName = "tabReview",
  shiny::fluidRow(
    column(2,

    shinycards::card(title = "Revisar resultados", icon = NULL, width = NULL,
                       shiny::selectInput("reviewProject", "Proyecto", FragmanUI:::res_name(FragmanUI:::list_projects() )
                       )
                     ,
                       shiny::uiOutput("reviewMarkerO")
    )
    ),

    column(10,
      shinycards::card(title = "Resultados", icon = NULL, width = NULL,
        shiny::tabsetPanel(
          tabPanel(title = "Formato binario",
            DT::dataTableOutput("reviewResults")
          )
        )

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

  vRv <- reactiveValues(doPlot = FALSE)

  observeEvent(input$reviewProject, {
    vRv$doTable <- FALSE
  })

  observeEvent(input$reviewMarker, {
    vRv$doTable <- FALSE
  })

  output$reviewResults <- DT::renderDataTable({


    pn <- input$reviewProject
    mn <- input$reviewMarker

    message(paste("mn =", mn))

    if(!is.character(mn)) return(NULL)
    #if(!is.vector(mn)) return(NULL)

    dr <- FragmanUI:::get_assay_dir(pn, mn)
    rn <- file.path(dr, "results")
    #fp <- file.path(rn, "scores.csv")
    #utils::write.csv(df, file = fp, row.names = FALSE)
    fb <- file.path(rn, "scores_bin.csv")
    fb <- stringr::str_replace_all(fb, "\\\\", "/")
    res <- read.csv(fb)
    DT::datatable(data = res,
                  options = list(scrollX = TRUE)
    )
  }
  )


}
