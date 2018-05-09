
get_resource_base_dir <- function() {
  file.path(rappdirs::user_data_dir(appname = department, appauthor = institute), "resources")
}

get_resource_abi_dir <- function() {
  fp <- file.path(get_resource_base_dir(), "ABI", "ladders")
  if(!dir.exists(fp)) {
    dir.create(fp, recursive = TRUE)
  }

  file.path(get_resource_base_dir(), "ABI")
}

add_ladder <- function(ladder) {

  tgt_name <- file.path(get_resource_abi_dir(),"ladders", names(ladder))
  saveRDS(ladder[[1]], file = tgt_name)

}

get_abi_ladders <- function() {
  file.path(get_resource_abi_dir(), "ladders")
}

list_ladders <- function() {
  list.files(get_abi_ladders())
}

read_ladder <- function(ladder_name) {
  fp <- file.path(get_abi_ladders(), ladder_name)
  data <- readRDS(fp)

  res <- list(data)
  names(res)[1] <- ladder_name

  res
}

