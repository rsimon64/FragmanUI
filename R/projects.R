institute <- function() {"INIA"}
department <- function() {"DRGB"}

act_year <- function() {stringr::str_sub(Sys.Date(), start = 1, 4)}
prefix_inv <- paste0("i_", act_year(), "_")
prefix_ass <- paste0("a_", act_year(), "_")

get_project_base_dir <- function() {
  file.path(rappdirs::user_data_dir(appname = department(), appauthor = institute()), "projects")
}

list_projects <- function() {
  list.dirs(get_project_base_dir(), recursive = FALSE)
}

get_project_dir <- function(project_ID) {
  file.path(get_project_base_dir(), paste0(prefix_inv, project_ID))
}

add_project <- function(project_ID = "demo") {
  project_path <- get_project_dir(project_ID)
  #message(project_path)
  if (dir.exists(project_path)) {
    return(TRUE)
  } else {
    dir.create(project_path, recursive = TRUE)
    return(TRUE)
  }
  return(FALSE)
}

get_assay_dir <- function(project_ID, assay_dir) {
  fp <- file.path(get_project_dir(project_ID), paste0(prefix_ass, basename(assay_dir)))
  if(!dir.exists(fp)) dir.create(fp, recursive = TRUE)
  fp
}

add_assay <- function(assay_src_dir, project_ID) {
  #if (!dir.exists(assay_src_dir)) return(FALSE)
  assay_path <- get_assay_dir(project_ID, assay_src_dir)
  if (!dir.exists(assay_path)) dir.create(assay_path)
  file.copy(assay_src_dir, assay_path, overwrite = TRUE, recursive = TRUE)
}

list_assays <- function(project_ID) {
  project_path <- get_project_dir(project_ID)
  assays <- basename(list.files(project_path, recursive = FALSE, pattern = "a_", include.dirs = TRUE))
  return(assays)
}

list_assay_files <- function(project_ID, assay_ID) {
  assay_data <- file.path(get_assay_dir(project_ID, assay_ID), "data")
  list.files(assay_data)
}




