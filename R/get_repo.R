library(magrittr)

get_repo <- function() {
  adir <- rappdirs::user_config_dir("fran", "DRGB", "1")
  if(!dir.exists(adir)) dir.create(adir, recursive = TRUE)
  conf <- file.path(adir, "config.yaml")
  if(!file.exists(conf)) {
    act_dir <- getwd()
    fran_conf <- list(repo_dir = act_dir) %>%
      yaml::write_yaml(conf)
    return(act_dir)
  } else {
    fran_conf <- yaml::yaml.load_file(conf, as.named.list = TRUE)
    return(fran_conf$repo_dir)
  }

}
