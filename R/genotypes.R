get_dir_genotypes <- function() {
  fp <- file.path(get_resource_base_dir(), "genotypes")
  if(!dir.exists(fp)) {
    dir.create(fp, recursive = TRUE)
  }
  fp
}

add_genotypes <- function(genotypes) {
  tgt_name <- file.path(get_dir_genotypes(), names(genotypes))
  saveRDS(genotypes[[1]], file = tgt_name)
}

read_genotypes <- function(genotypes) {
  fp <- file.path(get_dir_genotypes(), genotypes)
  data <- readRDS(fp)

  res <- list(data)
  names(res)[1] <- genotypes

  res
}


list_genotypes <- function(){
  list.files(get_dir_genotypes())
}
