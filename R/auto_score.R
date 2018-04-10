

#' auto_score
#'
#' @param folder string path to a folder with only ABI files
#' @param min_threshold integer, default: 5000
#' @param x_range integer vector; default: 200:500
#' @param channels integer vector; 1:5
#' @param my.ladder integer vector: default: LIZ600 values
#' @param marker string; a namer for the marker
#' @param plotting logical; whether to create plots or not; default: FALSE
#' @param ploidy integer; default 2; not yet implemented in Fragman
#' @param quality numeric; default: 0.9999. 1 would be highest
#'
#' @return data.frame of scoring results for each file or individual. Two columns for each marker (diploid).
#' @export
auto_score <- function(folder = choose.dir(), ploidy = 2,
                       min_threshold = 5000, x_range = c(200, 500),
                       channels = 1:5, my.ladder = liz600, marker = "mark", quality = .9999,
                       plotting = FALSE) {

  my.plants <- Fragman::storing.inds(folder)
  Fragman::ladder.info.attach(stored=my.plants, ladder=my.ladder, draw = FALSE)
  my.panel <- Fragman::overview2(my.inds=my.plants, channel = channels,
                        ladder=my.ladder, xlim = x_range,
                        init.thresh=min_threshold, ploidy = ploidy )
  fall <- as.data.frame(c(inds = list.files(folder)))
  names(fall) <- "inds"

  for(i in seq_along(channels)) {
    chi <- channels[i]
    chn <- paste0("channel_", chi)
    res <- Fragman::score.markers(my.inds=my.plants, channel = chi, panel=my.panel[[chn]],
                                  ploidy = ploidy,
                         ladder=my.ladder, electro=FALSE, plotting = plotting)

    fres <- Fragman::get.scores(res)
    fnms <- paste0( marker, c(1:ncol(fres)), "_",  chn)
    names(fres) <- fnms
    fall <- cbind(fall, fres)
  }

  corro <- unlist(lapply(list.data.covarrubias, function(x){x$corr}))
  bad_samples <- corro[corro < quality]

  attr(fall, "bad_samples" ) <- bad_samples

  return(fall)

}
