sv_abi <- function(input, output, session) {
  shinyFiles::shinyDirChoose(input, 'dir', roots = c(home = '~'), filetypes = c('abi', 'fsa'))
  dir <- shiny::reactive(input$dir)
  output$dir <- shiny::renderPrint(dir())

  old_path <- shiny::reactive({
    getwd()
  })

  path <- shiny::reactive({
    home <- normalizePath("~")

    file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
  })

  shiny::observeEvent(input$testBtn, {
    x <- choose.dir()
    message(x)
  })

  path_results <- shiny::reactive({
    rn <- get_results_dir(path())
    return(rn)
  })

  output$files <- shiny::renderPrint(list.files(path()))

  shiny::observeEvent(input$runScoresBtn, {
    # When the button is clicked, wrap the code in a call to `withBusyIndicatorServer()`
    withBusyIndicatorServer("runScoresBtn", {

      ladder <- stringr::str_split(input$ladderSizes, ", ")[[1]] %>% as.integer

      df <- FragmanUI::auto_score(
        folder = path(),
        channels = input$channels %>% as.integer,
        min_threshold = input$min_threshold %>% as.integer,
        x_range = input$x_range %>% as.integer,
        marker = input$markerName,
        myladder = ladder,
        quality = input$quality %>% as.numeric
      )

      bn <- basename(path())
      rn <- path_results()

      if(!dir.exists(rn)) dir.create(rn)

      fp <- file.path(rn, "scores.csv")
      utils::write.csv(df, file = fp, row.names = FALSE)
      saveRDS(df, file = file.path(rn, "scores.Rds"))

      #also store bin matrix together with quality scores
      fb <- file.path(rn, "scores_bin.csv")
      fb <- stringr::str_replace_all(fb, "\\\\", "/")
      score_bin <- convert_to_binary(scores = df)
      utils::write.csv(score_bin, file = fb)
      saveRDS(score_bin, file = file.path(rn, "scores_bin.Rds"))

      bad_samples <- attr(df, "bad_samples")

      fs <- file.path(rn, "samples_low_quality.csv")
      fs <- stringr::str_replace_all(fs, "\\\\", "/")
      utils::write.csv(bad_samples, fs)


      output$scoreResults <- DT::renderDataTable(df)

      params <- list(
        folder = path(),
        channels = input$channels,
        min_threshold = input$min_threshold,
        x_range = input$x_range,
        marker = input$markerName,
        ladder = list(
          name = input$ladderName,
          sizes = input$ladderSizes
        ),
        quality_threshold = input$quality
      )
      params <- yaml::as.yaml(params)
      yaml::write_yaml(params, file.path(rn, "params.yaml.txt"))


      scores <- df



      message("Genotipos de baja calidad son:")
      message(paste(names(attr(df, "bad_samples")), collapse = ", "))

    })
  })

  return(list(path = path, path_results = path_results))
}
