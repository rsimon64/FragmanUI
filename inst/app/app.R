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
        ui_genotypes,
        ui_import,
        ui_review,
        ui_analyze,
        ui_abi # this will be removed
      )
    )
  ),

  server = function(input, output, session) {
    notifications <<-  reactiveValues(
      note01 = list(id = "welcome", icon = "info", status = "success",
                    text = "Bienvenido1", href = NULL)
    )

    sv_std(input, output, session)
    sv_projects(input, output, session)
    sv_ladders(input, output, session)
    sv_markers(input, output, session)
    sv_genotypes(input, output, session)
    sv_import(input, output, session) # need to revise this
    sv_review(input, output, session)
    sv_analyze(input, output, session)
  },

  options = list(
    #port = 3141,
    launch.browser = TRUE
  )
)


