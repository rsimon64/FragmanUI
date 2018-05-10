lapply(list.files(".", "m_"), source)

shiny::shinyApp(
  ui = dashboardPage(
    skin = "green",
    sw_dashboardHeader("Analizar Fragmentos ADN", logo = "inia.jpg"),
    sidebar,
    dashboardBody(
      tabItems(
        ui_about,
        ui_projects,
        ui_ladders,
        ui_markers,
        ui_abi2,
        ui_import
      )
    )
  ),

  server = function(input, output, session) {
    sv_std(input, output, session)
    sv_projects(input, output, session)
    sv_ladders(input, output, session)
    sv_import(input, output, session)
  },

  options = list(
    port = 3141,
    launch.browser = TRUE
  )
)


