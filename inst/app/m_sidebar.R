
sm <- sidebarMenu(
  menuItem(
    text="Acerca de",
    tabName="tabAbout",
    icon=icon("info")
  )
  ,
  menuItem(
    text="A\u00F1adir recursos",
    icon=icon("plus"),
    menuSubItem(
      text="A\u00F1adir proyecto",
      tabName="tabProjects",
      icon=icon("folder")
    )
    ,
    menuSubItem(
      text="A\u00F1adir escalera molecular",
      tabName="tabLadders",
      icon=icon("align-justify")
    )
    ,
    menuSubItem(
      text="A\u00F1adir marcador molecular",
      tabName="tabMarkers",
      icon=icon("align-center")
    )
    ,
    menuSubItem(
      text="A\u00F1adir conjunto genotipos",
      tabName="tabGenotypes",
      icon=icon("object-group")
    )
  )
  ,
  menuItem(
    text="Archivar datos",
    icon=icon("archive"),
    menuSubItem(
      text="Importar archivos ABI",
      tabName="tabImport",
      icon=icon("upload")
    )
    ,

    menuSubItem(

      text="Evaluar",
      tabName="tabEvaluate",
      icon=icon("eye")
    ),

    menuSubItem(
      selected = TRUE,
      text="Analizar",
      tabName="tabAnalyze",
      icon=icon("table")
    )
    ,
    menuSubItem(
      text="Revisar resultados",
      tabName="tabReview",
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
  div(
    img(src="logo_app.png", width = "150px"),
  style="text-align: center;"),
  sm
  # ,
  # br(),
  # div(
  #   tags$button(
  #     id = 'close',
  #     type = "button",
  #     class = "btn action-button btn-warning",
  #     #class = "btn-warning",
  #     onclick = "setTimeout(function(){window.close();}, 10);",  # close browser
  #     "Cerrar programa"
  #   ),
  # style="text-align: center;")

)
