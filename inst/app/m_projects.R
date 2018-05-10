
ui_projects <- tabItem(
  tabName = "tabProjects",
  shiny::fluidRow(
    shinycards::card(width = 6, title = "Aadir proyecto", icon = NULL,
                     shiny::p(paste("Todos los proyectos tendran un prefijo interno de forma 'i_[a\u00F1o]'")),
                     shiny::p("Listado actual:"),
                     shiny::textOutput("projectList"),
                     shiny::textInput("projectID", "Nuevo proyecto:", placeholder = "nombre del proyecto"),
                     shiny::actionButton("btnAddProjectID", "Crear nuevo")
    )
  )
)

sv_projects <- function(input, output, session) {
  observeEvent(input$btnAddProjectID, {
    FragmanUI:::add_project(input$projectID)

    listP <- basename(FragmanUI:::list_projects())

    output$projectList <- renderText({
      paste(listP, collapse = ", ")
    })

    updateRadioButtons(session, "projectTgt", choices = listP)
    showNotification("Proyecto nuevo creado!.", type = "message", duration = NULL)
  })

  output$projectList <- renderText({
    paste(basename(FragmanUI:::list_projects()), collapse = ", ")
  })

}
