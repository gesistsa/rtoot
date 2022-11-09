fake_token <- list(bearer = Sys.getenv("RTOOT_DEFAULT_TOKEN"))
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"
class(fake_token) <- "rtoot_bearer"

test_that("get_status", {
  vcr::use_cassette("get_status_default", {
    id <- "109298295023649405"
    x <- get_status(id = id, token = fake_token)
  })
  expect_true("tbl_df" %in% class(x))
  expect_equal(x$id, id)
  vcr::use_cassette("get_status_noparse", {
    id <- "109298295023649405"
    x <- get_status(id = id, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  expect_equal(x$id, id)
  vcr::use_cassette("get_status_instance", {
    id <- "109294719267373593"
    x <- get_status(id = id, instance = "mastodon.social", token = fake_token)
  })
  expect_true("tbl_df" %in% class(x))
  expect_equal(x$id, id)
  vcr::use_cassette("get_status_anonymous", {
    id <- "109294719267373593"
    x <- get_status(id = id, instance = "mastodon.social", anonymous = TRUE, token = fake_token)
  })
  expect_true("tbl_df" %in% class(x))
  expect_equal(x$id, id)
})
