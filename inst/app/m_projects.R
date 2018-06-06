
ui_projects <- tabItem(
  tabName = "tabProjects",
  shiny::fluidRow(
    shinycards::card(width = 6, title = "A\u00F1adir proyecto", icon = NULL,
                     shiny::p(paste("Todos los proyectos tendran un prefijo interno de forma 'i_[a\u00F1o]'")),
                     shiny::textInput("projectID", "ID nuevo proyecto:", placeholder = "ID del proyecto"),
                     shiny::p("Nombre"),
                     shiny::p("Descripcion"),
                     shiny::p("Fecha inicio y final"),
                     shiny::p("otros see MiGen"),
                     shiny::actionButton("btnAddProjectID", "Crear nuevo")
    ),
    shinycards::card(width = 6, title = "", icon = NULL,
                     shiny::p("Listado actual:"),
                     shiny::textOutput("projectList")
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

    updateSelectInput(session, "importProjectTgt", choices = listP)
    updateSelectInput(session, "evaluateProject", choices = listP)
    showNotification("Proyecto nuevo creado!.", type = "message", duration = NULL)
  })

  output$projectList <- renderText({
    paste(basename(FragmanUI:::list_projects()), collapse = ", ")
  })

}
