library(shinyware)
library(FragmanUI)
library(shiny)
library(shinydashboard)
library(shinyFiles)

data("liz600")
# src <- system.file("apps/sample-01/www/inia.png", package = "shinyware")
# file.copy(src, "www/inia.jpg")

header1 <- sw_dashboardHeader("Analizar Fragmentos ADN", logo = "inia.jpg"#,
#
#
#                              shinydashboard::dropdownMenu(
#                                type = "notifications",
#                                icon = shiny::icon("question-circle"),
#                                badgeStatus = NULL,
#                                headerText = "See also:",
#
#                                shinydashboard::notificationItem("Tutorial", icon = shiny::icon("file"),
#                                                                 href = "tutorial_english.html")
#                              )
)


sm <- sidebarMenu(
  # menuItem(
  #   text="Acerca de",
  #   tabName="tabAbout",
  #   icon=icon("info")
  # )
  #,
  menuItem(
    text="Manejar proyectos",
    tabName="tabProjects",
    icon=icon("folder")
  )
  ,
  menuItem(
    text="Importar archivos ABI",
    tabName="tabImport",
    icon=icon("upload")
    )
  ,
  menuItem(
    text="Manejar escaleras moleculares",
    tabName="tabLadders",
    icon=icon("align-justify")
  )
  ,
  # menuItem(
  #   text="Evaluar archivos ABI",
  #   tabName="tabABIexplore",
  #   icon=icon("eye")
  # ),
  menuItem(
    text="Analizar archivos ABI",
    tabName="tabABIanalyze",
    icon=icon("table")
  )
  #,
  # menuItem(
  #   text="Revisar tabla resultados",
  #   tabName="tabABIreview",
  #   icon=icon("check")
  # ),
  # menuItem(
  #   text="Documentar experimento",
  #   tabName="tabABImeta",
  #   icon=icon("edit")
  # ),
  # menuItem(
  #   text="Preparar reporte ABI",
  #   tabName="tabABIreport",
  #   icon=icon("file")
  # )
  #,
  # menuItem(
  #   text="Bajar resultados ",
  #   tabName="tabABIexport",
  #   icon=icon("download")
  # )
)


sidebar <- shinydashboard::dashboardSidebar(
  br(),
  div(img(src="logo_app.png", width = "150px"), style="text-align: center;"),
  sm
)



body <- shinydashboard::dashboardBody(
  tabItems(
    tabItem(
      tabName = "tabAbout",
      shiny::fluidRow(
        shinycards::card(width = 6,
          shiny::HTML(
            readLines(system.file("doc/tutorial_castellano2.html", package="FragmanUI"))
          )
        )
      )
    ),
    tabItem(
      tabName = "tabProjects",
      shiny::fluidRow(
        shinycards::card(width = 6, title = "Nuevo proyecto", icon = NULL,
                         shiny::p(paste("Todos los proyectos tendran un prefijo interno de forma 'i_[año]'")),
                         shiny::p("Listado actual:"),
                         shiny::textOutput("projectList"),
                         shiny::textInput("projectID", "Nuevo proyecto:", placeholder = "nombre del proyecto"),
                         shiny::actionButton("btnAddProjectID", "Crear nuevo")
        )
      )
    ),
    tabItem(
      tabName = "tabLadders",
      shiny::fluidRow(
        shinycards::card(width = 6, title = "Manejar escaleras moleculares", icon = NULL,
                         shiny::p("Listado actual:"),
                         shiny::textOutput("ladderList")

        )
      )
    ),
    tabItem(
      tabName="tabABIanalyze",
      FragmanUI:::ui_abi()
    ),
    tabItem(
      tabName = "tabImport",
      shiny::fluidRow(

        shinycards::card(width = 6, title = "Importar archivos ABI", icon = NULL,

                      shiny::radioButtons("projectTgt", "Proyecto destino", basename(FragmanUI:::list_projects())),

                      shinyFiles::shinyDirButton('btnAbiSrcDir', 'Directorio con archivos', 'Seleccione un folder'),

                      shiny::h4("Archivos en el directorio seleccionado")

        ),
        shinycards::card(width = 6, title = "Archivos importados", icon = NULL,
                      shiny::p("Solo mostrando hasta los primeros 20 archivos")   ,
                      shiny::htmlOutput("abiImported")


        )
      )
    )
  )
)

ui_app <- shinydashboard::dashboardPage(
  skin = "green", header1, sidebar, body
)




sv_app <- function(input, output, session) {
  #FragmanUI:::sv_abi(input, output, session)
  output$notificationMenu <- shinydashboard::renderMenu({

    shinydashboard::dropdownMenu(type = "notifications",
                                 #icon = shiny::icon("question-circle"),
                                 badgeStatus = NULL#,
                                # headerText = "See also:",
                                 # shinydashboard::notificationItem("about", icon = shiny::icon("file"),
                                 #                                  href = "#shiny-tab-tabAbout")
    )
  })

  volumes <- c( "Base" = Sys.getenv("Home"))
  shinyFiles::shinyDirChoose(input, 'btnAbiSrcDir', roots = volumes, session=session)


  abiSrcPath <- shiny::reactive({
    shinyFiles::parseDirPath(volumes, input$btnAbiSrcDir)
  })


  observeEvent(input$btnAddProjectID, {
    FragmanUI:::add_project(input$projectID)

    listP <- basename(FragmanUI:::list_projects())

    output$projectList <- renderText({
      paste(listP, collapse = ", ")
    })

    updateRadioButtons(session, "projectTgt", choices = listP)
    showNotification("Proyecto nuevo creado!.", type = "message", duration = NULL)
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


  output$projectList <- renderText({
    paste(basename(FragmanUI:::list_projects()), collapse = ", ")
  })

  output$ladderList <- renderText({
    paste(FragmanUI:::list_ladders(), collapse = ", ")
  })

  session$onSessionEnded(function() {
    shiny::stopApp()
  })

}




shiny::shinyApp(
  ui = ui_app,
  server = sv_app,
  options = list(
    port = 3141,
    launch.browser = TRUE
  )
)
