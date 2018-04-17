assemble_images_by_id <- function(folder) {

  library(magrittr)
  results_dir <- get_results_dir(folder)
  image_dir <- file.path(results_dir, "images")
  report_dir <- file.path(results_dir, "reports", "basic")
  if(!dir.exists(report_dir)) {
    dir.create(report_dir)
  }

  # get list of unique ids
  sr <- readRDS(file.path(results_dir, 'scores.Rds'))
  sb <- readRDS(file.path(results_dir, 'scores_bin.Rds'))

  sbnms <- sb %>% row.names()#  %>% unique  %>% sort()


  # assemble a markdown page with table of images channels(rows) by types(columns).
  # column: channel id, electro gel, individual reading
  yml <- yaml::read_yaml(file.path(results_dir,"params.yaml.txt")) %>% yaml::yaml.load()
  channel_id <- yml$channels

  # get unique list of ids from results table
  sbid <- stringr::str_replace_all(sbnms, ".fsa", "")

  # get template
  tpl <- system.file("templates/reports/basic_gel_by_id.moustache", package = "FragmanUI")
  tpl <- readLines(tpl)
  # from there construct list of images and resulting summary images


  for(i in 1:length(sbid)) {
    report_env <- globalenv()
  #i = 2
    sbidi <- sbid[i]
    ascan <- paste0("../../../images/", sbnms[i], "_channel_", paste0(channel_id, ".png"))
    # check if indeed present
    # all(file.exists(file.path(image_dir, scimg)))
    electro <- paste0("../../../images/electro_gel_channel_", paste0(channel_id, ".png"))

    mscores <- sr[i, c(2: ncol(sr))]
    sets <- seq(1, ncol(mscores), 2)
    mdf <- as.data.frame(cbind(m1 = 0, m2 = 0))
    for(j in seq_along(sets)) {
      #print(sets[j])
      mr <- mscores[c(sets[j],sets[j]+1)]
      mr <- as.data.frame(mr)
      names(mr) <- c("m1", "m2")
      #print(mr)
      mdf <- rbind(mdf, mr)
    }
    mdf <- mdf[-1, ]
    mscores <- rep(NA, nrow(mdf))
    for(j in 1:nrow(mdf)) {
      mscores[j] <- paste(round(mdf[j, ], 4), collapse = " " )
    }


    scans <- as.data.frame(cbind(channel_id, ascan, electro, mscores))
    scans <- unname(whisker::rowSplit(scans))
    orgid <- sbid[i]
    quality <- round(sb$quality[i], 4)
    sbidmd <- whisker::whisker.render(tpl,data = report_env)

    # fn <- stringr::str_replace_all(sbid[i], "_", "-")
    # fn <- stringr::str_replace_all(fn, "-", "")
    # fn <- stringr::str_replace_all(fn, "\\.", "")
    writeLines(sbidmd, paste0(sbid[i], ".Rmd"))
    #rmarkdown::render(paste0(sbid[i], ".md"), output_file = paste0(sbid[i], ".html"))

  }
  # cycle through images and create pages in bookdown format in a new sub directory for reports
  # within that a new subdirectory for this type of report 'basic'

  # then transfer additional files from templates (index.Rmd, corr.Rmd)


}
