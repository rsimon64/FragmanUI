
calc_PIC <- function(scores_bin, markers) {
  message("Se assume que escoreos son diploides y homozigotos han sido escoreados como 2.")
  message("Se assume que escoreos no tienen datos faltantes.")

  # Remove quality column

  # calculate total of diploid markers = 2 * individuals.

  sb <- scores_bin[, -c(1)]
  total_allels <- 2 * nrow(sb)

  freq <- colSums(sb) / total_allels
  freq <- freq * freq

  marker <- rep(" ", length(freq))
  freq <- as.data.frame(cbind(names(freq), marker, freq), stringsAsFactors = FALSE)

  # grouping preliminaries
  for(i in seq_along(markers)) {
    has_marker <- stringr::str_detect(freq[, 1], markers[i])
    freq[has_marker, "marker"] <- markers[i]
  }
  freq$freq <- as.numeric(freq$freq)

  freq <- freq %>% dplyr::group_by(marker) %>% dplyr::summarise(1 - sum(freq))
  names(freq)[2] <- "PIC"

  return(freq)
}
