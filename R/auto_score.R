

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
#'
#' @return data.frame of scoring results for each file or individual. Two columns for each marker (diploid).
#' @export
auto_score <- function(folder = choose.dir(), ploidy = 2,
                       min_threshold = 5000, x_range = c(200, 500),
                       channels = 1:5, myladder = liz600, marker = "mark", quality = .9999,
                       plotting = FALSE) {

  # print(folder)
  # print(ploidy)
  # print(min_threshold)
  # print(x_range)
  # print(channels)
  # print(myladder)
  # print(marker)
  # print(quality)
  # print(plotting)

  message("1\n")
  my.plants <- Fragman::storing.inds(folder)
  message("2\n")
  Fragman::ladder.info.attach(stored=my.plants, ladder=myladder, draw = FALSE)
  message("3\n")
  my.panel <- Fragman::overview2(my.inds=my.plants, channel = channels,
                        ladder = myladder, xlim = x_range, init.thresh =  min_threshold,
                         ploidy = ploidy )
  message("4\n")
  fall <- as.data.frame(c(inds = list.files(folder)))
  names(fall) <- "inds"

  message("5\n")
  for(i in seq_along(channels)) {
    chi <- channels[i]
    message(paste("for ", chi, "\n"))
    chn <- paste0("channel_", chi)
    #message(my.panel[[chn]])
    res <- Fragman::score.markers(my.inds=my.plants,
                                  channel = chi,
                                  panel=my.panel[[chn]],
                                  #panel = x_range,
                                  #ploidy = ploidy,
                                  ladder=myladder)
    message(paste("for res", chi, "\n"))
    fres <- Fragman::get.scores(res)
    message(paste("for fres", chi, "\n"))
    fnms <- paste0( marker, c(1:ncol(fres)), "_",  chn)
    message(paste("for fms", chi, "\n"))
    names(fres) <- fnms
    fall <- cbind(fall, fres)
  }

  corro <- unlist(lapply(list.data.covarrubias, function(x){x$corr}))
  bad_samples <- corro[corro < quality]

  attr(fall, "bad_samples" ) <- bad_samples

  return(fall)

}
