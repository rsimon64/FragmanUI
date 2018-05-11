

ui_review <- tabItem(
  tabName = "tabReview",
  shiny::fluidRow(
    column(4,

    shinycards::card(title = "Revisar resultados", icon = NULL, width = NULL,
                       shiny::selectInput("reviewProject", "Proyecto", FragmanUI:::res_name(FragmanUI:::list_projects() )
                       )
                     # ,
                     #   shiny::uiOutput("reviewMarkerO")
                     # ,
                     #    br(),
                     #    br(),
                     #    div(
                     #      shinyjs::hidden(p(id = "revHint", "Favor revisar parametros antes de analizar.")),
                     #      shiny::actionButton('btnReview', 'Analizar archivos',
                     #                          class = "btn action-button btn-primary")
                     #      , style="text-align: center;")
                     #
                     )
    )

  )
)



sv_review <- function(input, output, session) {

}
