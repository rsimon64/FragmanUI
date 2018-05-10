context("calc_PIC")


# https://repository.cimmyt.org/xmlui/bitstream/handle/10883/3493/79065.pdf


scores_bin <- as.data.frame(cbind(
  quality = rep(1, 7),
  ssr1a = c(2, 0, 2, 2, 1, 0, 0),
  ssr1b = c(0, 2, 0, 0, 0, 1, 0),
  ssr1c = c(0, 0, 0, 0, 1, 1, 1),
  ssr1d = c(0, 0, 0, 0, 0, 0, 1),

  ssr2a = c(1, 2, 1, 0, 2, 1, 2),
  ssr2b = c(1, 0, 0, 2, 0, 1, 0),
  ssr2c = c(0, 0, 1, 0, 0, 0, 0)
)
)

# ssr <- FragmanUI:::calc_PIC(scores_bin, c("ssr1", "ssr2"))
#
# test_that("PIC works", {
#   expect_that( ssr$PIC[1] >= 0.653, is_true())
#   expect_that( ssr$PIC[2] == 0.5, is_true())
# })
