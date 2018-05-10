
ui_import <- tabItem(
  tabName = "tabImport",
  shiny::fluidRow(

    shinycards::card(width = 6, title = "Importar archivos ABI", icon = NULL,
                     shinyFiles::shinyDirButton('btnAbiSrcDir', 'Directorio con archivos', 'Seleccione un folder'),
                     shiny::selectInput("importAbiMarker", "Asociar marcador", FragmanUI:::list_markers()  ),
                     shiny::selectInput("importAbiLadder", "Asociar escalera", FragmanUI:::list_ladders()  ),
                     shiny::selectInput("importAbiGenotypes", "Asociar grupo genotipos", FragmanUI:::list_genotypes()  ),
                     shiny::selectInput("projectTgt", "Proyecto destino", basename(FragmanUI:::list_projects()))
    ),
    shinycards::card(width = 6, title = "Archivos importados", icon = NULL,
                     shiny::p("Solo mostrando hasta los primeros 20 archivos")   ,
                     shiny::htmlOutput("abiImported")


    )
  )
)


sv_import <- function(input, output, session) {
  volumes <- c( "Base" = Sys.getenv("Home"), "Data" = file.path("D:"))
  shinyFiles::shinyDirChoose(input, 'btnAbiSrcDir', roots = volumes, session=session)


  abiSrcPath <- shiny::reactive({
    shinyFiles::parseDirPath(volumes, input$btnAbiSrcDir)
  })

  observeEvent(input$btnAbiSrcDir, {

    prefix <- paste0("i_", FragmanUI:::act_year(), "_")
    tgt <- stringr::str_replace(input$projectTgt, prefix, "")
    shiny::withProgress(message = 'Procesando ...', style = "notification", value = 1,{
      FragmanUI:::add_assay(abiSrcPath(), tgt)
    }
    )
    showNotification("Archivos importados!.", type = "message", duration = NULL)
    output$abiImported <- renderText({
      # message(tgt)
      # message(basename(abiSrcPath()))
      fls <- basename(FragmanUI:::list_assay_files(tgt, basename(abiSrcPath())))
      #message(fls)

      paste0("Total archivos importados: ", length(fls), "<br/>", paste(fls, collapse = "</br>"))
    })
  })
}
