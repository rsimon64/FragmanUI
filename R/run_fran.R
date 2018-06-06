#' run_fran
#'
#' Runs a shiny app to analyze sequence fragments.
#'
#' Uses Fragman in the backend.
#'
#' @param port integer, default 9876
#'
#' @return NULL invisible
#' @author Reinhard Simon
#' @export
#'
#' @examples
#'
#' if(interactive()) {
#'    FragmanUI::run_fran()
#' }
#'
run_fran <- function(port = 9876) {

  shiny::runApp(system.file("app", package = "FragmanUI"))



}
