#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`


res_name <- function(x) {
  x_name <- function(x) {
    x <- basename(x)
    stringr::str_split(x, "_")[[1]][3]
  }

  unlist(lapply(x, x_name))
}
