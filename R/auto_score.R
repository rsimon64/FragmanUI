

#' auto_score
#'
#' @param folder string path to a folder with only ABI files
#' @param min_threshold integer, default: 5000
#' @param x_range integer vector; default: 200:500
#' @param channels integer vector; 1:5
#' @param myladder integer vector: default: LIZ600 values
#' @param marker string; a namer for the marker
#' @param plotting logical; whether to create plots or not; default: FALSE
#' @param ploidy integer; default 2; not yet implemented in Fragman
#' @param quality numeric; default: 0.9999. 1 would be highest
#' @importFrom utils choose.dir
#' @importFrom magrittr '%>%'
#'
#' @return data.frame of scoring results for each file or individual. Two columns for each marker (diploid).
#' @export
auto_score <- function(folder = choose.dir(), ploidy = 2,
                       min_threshold = 5000, x_range = c(200, 500),
                       channels = 1:5, myladder = liz600, marker = "mark", quality = .9999,
                       plotting = FALSE) {

  # message(
  #   paste(
  #     folder,
  #     min_threshold,
  #     x_range,
  #     channels,
  #     myladder,
  #     marker,
  #     quality,
  #     plotting,
  #     sep="\n"
  #   )
  # )

  score_env <- globalenv()

  my.plants <- Fragman::storing.inds(folder)
  Fragman::ladder.info.attach(stored=my.plants, ladder=myladder, draw = FALSE,
                              env = score_env)
  my.panel <- Fragman::overview2(my.inds=my.plants, channel = channels,
                        ladder = myladder, xlim = x_range, init.thresh =  min_threshold,
                         ploidy = ploidy, env = score_env )
  fall <- as.data.frame(c(inds = list.files(folder)))

  for(i in seq_along(channels)) {
    chi <- channels[i]
    chn <- paste0("channel_", chi)
    res <- Fragman::score.markers(my.inds=my.plants,
                                  channel = chi,
                                  panel=my.panel[[chn]],
                                  env = score_env,
                                  ladder=myladder)
    fres <- Fragman::get.scores(res)
    fnms <- paste0( marker, c(1:ncol(fres)), "_",  chn)
    names(fres) <- fnms
    fall <- cbind(fall, fres)
  }
  names(fall)[1] <- "ids"

  corro <- unlist(lapply(list.data.covarrubias, function(x){x$corr}))
  bad_samples <- corro[corro <= quality]

  attr(fall, "bad_samples" ) <- bad_samples
  attr(fall, "quality" ) <- corro

  return(fall)

}
