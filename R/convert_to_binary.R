
#' Convert To Binary
#'
#' @param scores data.frame of score results
#'
#' @return a data.frame
#' @export
#'
#' @examples
#'
#' # library(FragmanUI)
#' #
#' # scores <- auto_score()
#' # score_bin <- convert_to_binary(scores)
convert_to_binary <- function(scores = NULL) {

  # in pairs of columns!
  # TODO: some minimal checks
  stopifnot(!is.null(scores))


  names(scores)[1] <- "ids"

  num_to_bin <- function(scores, i) {
    all_scores <- c(scores[, i], scores[, i + 1]) %>% unique %>% sort()

    get_bin_mat <- function(scores, all_scores) {
      bin_mat <- matrix(0, nrow = nrow(scores), ncol = length(all_scores) )
      return(bin_mat)
    }

    transpose_scores <- function(scores, all_scores) {
      for(j in seq_along(all_scores)) {
        bin_mat[, j ] <- scores %in% all_scores[j]
      }

      return(bin_mat)
    }


    bin_mat <- get_bin_mat(scores, all_scores)
    bin_mat1 <- transpose_scores(scores[, i], all_scores)
    bin_mat2 <- transpose_scores(scores[, i + 1], all_scores)

    bin_mat <- bin_mat1 + bin_mat2

    nms <- stringr::str_replace(names(scores)[i], "[0-9]{1}_", "_")
    nms <-  paste(nms, round(all_scores, 4), sep =  "_")
    bin_mat <- as.data.frame(bin_mat)
    names(bin_mat) <- nms
    row.names(bin_mat) <- scores[, 1]

    return(bin_mat)
  }


  ploidy <- 2
  sets <- seq(2, ncol(scores), ploidy)
  quality <- attr(scores, "quality")
  if(length(quality) == 0) {
    quality <- rep(1, nrow(scores))
  }
  res_bin <- as.data.frame(quality)


  for(k in seq_along(sets)) {

    res <- num_to_bin(scores, sets[k])
    res_bin <- cbind(res_bin, res)
  }

  # quality <- attr(scores, "quality")
  # if(!is.null(quality)) {
  #   res_bin <- cbind(quality, res_bin)
  # }
  row.names(res_bin) <- scores$ids
  return(res_bin)

}
