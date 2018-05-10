
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
      selected = TRUE,
      text="Evaluar",
      tabName="tabReview",
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
  div(img(src="logo_app.png", width = "150px"), style="text-align: center;"),
  sm
)
