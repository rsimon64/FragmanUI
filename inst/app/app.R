library(shinyware)
library(FragmanUI)
library(shiny)
library(shinydashboard)
library(shinyFiles)

#utils::data("liz600")
 # src <- system.file("apps/sample-01/www/inia.png", package = "shinyware")
 # file.copy(src, "inst/www/inia.jpg")

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
  menuItem(
    text="Acerca de",
    tabName="tabAbout",
    icon=icon("info")
  )
  ,
  menuItem(
    text="Añadir recursos",
    icon=icon("plus"),
    menuSubItem(
      text="Añadir proyecto",
      tabName="tabProjects",
      icon=icon("folder")
    )
    ,
    menuSubItem(
      text="Añadir escalera molecular",
      tabName="tabLadders",
      icon=icon("align-justify")
    )
    ,
    menuSubItem(
      text="Añadir marcador molecular",
      tabName="tabMarkers",
      icon=icon("align-center")
    )
    ,
    menuSubItem(
      text="Añadir conjunto genotipos",
      tabName="tabGenotypes",
      icon=icon("align-center")
    )
  )
  ,
  menuItem(
    text="Collectar datos",
    icon=icon("wrench"),
    menuSubItem(
      text="Importar archivos ABI",
      tabName="tabImport",
      icon=icon("upload")
    )
    ,

    menuSubItem(
      text="Evaluar",
      tabName="tabABIexplore",
      icon=icon("eye")
    ),

    menuSubItem(
      text="Analizar",
      tabName="tabABIanalyze",
      icon=icon("table")
    )
    ,
    menuSubItem(
      text="Revisar resultados",
      tabName="tabABIreview",
      icon=icon("check")
    ),
    menuSubItem(
      text="Documentar",
      tabName="tabABImeta",
      icon=icon("edit")
    )
  )
  ,

  menuItem(
    text="Preparar reporte",
    tabName="tabABIreport",
    icon=icon("file")
  )
  ,
  menuItem(
    text="Bajar resultados ",
    tabName="tabABIexport",
    icon=icon("download")
  )
)


sidebar <- shinydashboard::dashboardSidebar(
  br(),
  div(img(src="inia.jpg", width = "150px"), style="text-align: center;"),
  sm
)



body <- shinydashboard::dashboardBody(
  tabItems(
    tabItem(
      tabName = "tabAbout",
      shiny::fluidRow(
        shinycards::card(width = 6,
          shiny::HTML(""
            #readLines(system.file("doc/tutorial_castellano2.html", package="FragmanUI"))
          )
        )
      )
    ),
    tabItem(
      tabName = "tabProjects",
      shiny::fluidRow(
        shinycards::card(width = 6, title = "Añadir proyecto", icon = NULL,
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
        shinycards::card(width = 6, title = "Añadir escalera molecular", icon = NULL,
                         shiny::p("Listado actual:"),
                         shiny::textOutput("ladderList"),
                         shiny::br(),
                         shiny::textInput("ladderID", "Nombre nueva escalera molecular:", placeholder = "nombre900"),
                         shiny::textAreaInput("ladderBp", "Listado de pesos moleculares separados por comma",
                                              placeholder = "30, 60, 90, ..."),
                         shiny::actionButton("btnAddLadderID", "Crear nueva")

        )
      )
    ),
    tabItem(
      tabName = "tabMarkers",
      shiny::fluidRow(
        shinycards::card(width = 6, title = "Añadir marcador molecular", icon = NULL,
                         shiny::p("Listado actual:"),
                         shiny::textOutput("markerList"),
                         shiny::br(),
                         shiny::textInput("markerID", "Nombre nuevo marcador molecular:", placeholder = "m123"),
                         shiny::textAreaInput("markerNotes", "Referencia y notas",
                                              placeholder = "Referencia y notas"),
                         #shiny::p("ladder"),
                         shiny::selectInput("markerLadder", "Asociar escalera molecular", choices = FragmanUI:::list_ladders()),
                         #shiny::p("bp range"),
                         shiny::sliderInput("markerRange", "Rango bp", 0, 1000, c(200, 340) ),
                         #shiny::p("channels"),
                         shiny::checkboxGroupInput("channels", "Canales preferidos",  1:5,
                                                   selected = 1:5, inline = TRUE),
                         #shiny::p("lumbral"),
                         shiny::sliderInput("markerThreshold", "Umbral mínimo", 0, 10000, 3000, step = 100),
                         shiny::br(),

                         shiny::actionButton("btnAddMarker", "Crear nuevo marcador")

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
                      shinyFiles::shinyDirButton('btnAbiSrcDir', 'Directorio con archivos', 'Seleccione un folder')
                      # ,
                      # shiny::h4("Archivos en el directorio seleccionado")
                      ,
                      shiny::p("Asociar marcador"),
                      shiny::p("Asociar populación"),
                      shiny::radioButtons("projectTgt", "Proyecto destino", basename(FragmanUI:::list_projects()))



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

  volumes <- c( "Base" = Sys.getenv("Home"), "Data" = file.path("D:"))
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
