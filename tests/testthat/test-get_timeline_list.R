fake_token <- list(bearer = Sys.getenv("RTOOT_DEFAULT_TOKEN"))
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"
class(fake_token) <- "rtoot_bearer"

test_that("get_timeline_list", {
  vcr::use_cassette("get_timeline_list_default", {
    x <- get_timeline_list(list_id = "2507", limit = 5, parse = TRUE, token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_list_noparse", {
    x <- get_timeline_list(list_id = "2507", limit = 5, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
})
