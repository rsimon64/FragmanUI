assemble_images_by_id <- function(folder) {
  library(magrittr)
  results_dir <- get_results_dir(folder)
  image_dir <- file.path(results_dir, "images")
  report_dir <- file.path(results_dir, "reports", "basic")
  if(!dir.exists(report_dir)) {
    dir.create(report_dir)
  }

  # get list of unique ids
  sb <- readRDS(file.path(results_dir, 'scores_bin.Rds')) %>% row.names()  %>% unique  %>% sort()

  sbid <- stringr::str_replace_all(sb, ".fsa", "")

  # assemble a markdown page with table of images channels(rows) by types(columns).
  # first column: electro gel, 2nd column individual reading

  # get unique list of ids from results table

  # from there construct list of images and resulting summary images
  # check if indeed present

  # cycle through images and create pages in bookdown format in a new sub directory for reports
  # within that a new subdirectory for this type of report 'basic'


}
