
# params list
save_scan_params <- function(params, project_ID, marker_ID) {
  fp <- file.path(get_assay_dir(project_ID, marker_ID), "params")
  saveRDS(params, file = fp)
}

# return list
read_scan_params <- function(project_ID, marker_ID) {
  fp <- file.path(get_assay_dir(project_ID, marker_ID), "params")
  readRDS(fp)
}
