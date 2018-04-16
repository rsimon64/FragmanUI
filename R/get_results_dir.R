get_results_dir <- function(adir) {
  rn <- stringr::str_sub(adir, 1, nchar(adir) - nchar(basename(adir)))
  rn <- paste0(rn, "results")
}
