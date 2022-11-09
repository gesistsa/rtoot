fake_token <- list(bearer = Sys.getenv("RTOOT_DEFAULT_TOKEN"))
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"
class(fake_token) <- "rtoot_bearer"

test_that("get_home_timeline", {
  vcr::use_cassette("get_home_timeline_default", {
    x <- get_home_timeline(limit = 5, parse = TRUE, token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_home_timeline_noparse", {
    x <- get_home_timeline(limit = 5, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  ## won't do much. ?really working at the API
  vcr::use_cassette("get_home_timeline_local", {
    y <- get_home_timeline(local = TRUE, limit = 5, parse = TRUE, token = fake_token)
  })
  expect_true(nrow(y) == 5)
  expect_true("tbl_df" %in% class(y))
})
