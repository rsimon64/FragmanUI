sv_abi <- function(input, output, session) {
 # vals <- reactiveValues(repo_path = NULL)
  volumes <- c('ABI folder' = get_repo(), "Base" = Sys.getenv("Home"))
  shinyFiles::shinyDirChoose(input, 'btnAbiDir', roots = volumes, session=session)

  # path <- shiny::eventReactive(input$btnAbiDir, {
  #   repo <- get_repo()
  #   select_folder(repo, "Seleccionar folder")
  # })

  path <- shiny::reactive({
    shinyFiles::parseDirPath(volumes, input$btnAbiDir)
  })

  path_results <- shiny::reactive({
    rn <- get_results_dir(path())
    return(rn)
  })

  output$files <- shiny::renderPrint({

    message(list.files(path()) )
    list.files(path())
  })

  shiny::observeEvent(input$runScoresBtn, {
    shiny::updateActionButton(session, "runScoresBtn", label ="Procesando", icon = shiny::icon("spinner"))

    withProgress(message = 'Procesando ...', style = "notification", value = 1, {


      ladder <- stringr::str_split(input$ladderSizes, ", ")[[1]] %>% as.integer

      #message(path())

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

      shiny::updateActionButton(session, "runScoresBtn", label ="Exito", icon = shiny::icon("check"))

    }
    )
  })

  return(list(path = path, path_results = path_results))
}
