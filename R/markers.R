get_resource_dir_markers <- function() {
  fp <- file.path(get_resource_base_dir(), "markers")
  if(!dir.exists(fp)) {
    dir.create(fp, recursive = TRUE)
  }
  fp
}

add_marker <- function(marker) {
  tgt_name <- file.path(get_resource_dir_markers(), names(marker))
  saveRDS(marker[[1]], file = tgt_name)
}

read_marker <- function(marker) {
  fp <- file.path(get_resource_dir_markers(), marker)
  data <- readRDS(fp)

  res <- list(data)
  names(res)[1] <- marker

  res
}



list_markers <- function() {
  list.files(get_resource_dir_markers())
}
