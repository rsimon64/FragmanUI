do_report_basic <- function(folder) {

  library(magrittr)
  results_dir <- get_results_dir(folder)
  image_dir <- file.path(results_dir, "images")
  report_dir <- file.path(results_dir, "reports", "basic")
  #message(report_dir)
  if(!dir.exists(report_dir)) {
    dir.create(report_dir)
  }

  #withr::with_dir(report_dir, {



  # get list of unique ids
  sr <- readRDS(file.path(results_dir, 'scores.Rds'))
  sb <- readRDS(file.path(results_dir, 'scores_bin.Rds'))

  sbnms <- sb %>% row.names()#  %>% unique  %>% sort()
  #message(sbnms)

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
  #print(sr)
  #print(sbnms)

  for(ii in seq_along(sbid)) {

  #i = 2
    sbidi <- sbid[ii]
    #print(sbidi)
    ascan <- paste0(image_dir, "/", sbnms[ii], "_channel_", paste0(channel_id, ".png"))
    # check if indeed present
    # all(file.exists(file.path(image_dir, scimg)))
    electro <- paste0(image_dir, "/electro_gel_channel_", paste0(channel_id, ".png"))
    #print(ascan)
    #print(electro)

    mscores <- sr[ii, c(2: ncol(sr))]
    sets <- seq(1, ncol(mscores), 2)
    mdf <- as.data.frame(cbind(m1 = 0, m2 = 0))
    #print(sets)
    for(j in seq_along(sets)) {
      #print(sets[j])
      mr <- mscores[c(sets[j],sets[j]+1)]
      mr <- as.data.frame(mr)
      names(mr) <- c("m1", "m2")
      #print(mr)
      mdf <- rbind(mdf, mr)
    }
    mdf <- mdf[-1, ]
    #print(mdf)
    mscores <- rep(NA, nrow(mdf))
    for(j in 1:nrow(mdf)) {
      mscores[j] <- paste(round(mdf[j, ], 4), collapse = " " )
    }

    report_env <- globalenv()
    scans <- as.data.frame(cbind(channel_id, ascan, electro, mscores))
    scans <- unname(whisker::rowSplit(scans))
    #print(scans)
    orgid <- sbid[ii]
    quality <- round(sb$quality[ii], 4)
    sbidmd <- withr::with_dir(report_dir, {
      whisker::whisker.render(tpl, data = list(scans = scans, orgid = orgid, quality = quality))
    })


    # fn <- stringr::str_replace_all(sbid[i], "_", "-")
    # fn <- stringr::str_replace_all(fn, "-", "")
    # fn <- stringr::str_replace_all(fn, "\\.", "")
    writeLines(sbidmd, file.path(report_dir, paste0(sbid[ii], ".Rmd")))
    #rmarkdown::render(paste0(sbid[i], ".md"), output_file = paste0(sbid[i], ".html"))

  }

  # copy over an index file from templates, too.
  src <- system.file(file.path("templates", "reports", "index.moustache"), package = "FragmanUI")
  # tgt <- file.path(report_dir, "index.Rmd")
  # file.copy(src, tgt)

  tpl <- readLines(src)

  scb <- withr::with_dir(report_dir, {
    whisker::whisker.render(tpl, data = list(results_dir = results_dir))
  })
  writeLines(scb, file.path(report_dir, paste0("index.Rmd")))


  # run bookdown using withr::with_dir !
  unlink(file.path(report_dir, "_reporte"), recursive = TRUE, force = TRUE)
  #})
  withr::with_dir(report_dir, {
    bookdown::render_book(list.files(pattern=".Rmd"), output_dir = "_reporte")
  })
  browseURL(file.path(report_dir, "_reporte", "index.html"))

  # then transfer additional files from templates (index.Rmd, corr.Rmd)


}
