fake_token <- list(bearer = Sys.getenv("RTOOT_DEFAULT_TOKEN"))
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"
class(fake_token) <- "rtoot_bearer"

test_that("get_public_timeline", {
  vcr::use_cassette("get_public_timeline_default", {
    x <- get_public_timeline(token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_public_timeline_notparse", {
    x <- get_public_timeline(parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_public_timeline_instance", {
    x <- get_public_timeline(instance = "mastodon.social", token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x)) ## we can't test because it can contain statuses from another instance
  vcr::use_cassette("get_public_timeline_instance_local", {
    x <- get_public_timeline(local = TRUE, limit = 10, token = fake_token)
  })
  ## it should have only one type of hostname
  expect_equal(length(unique(sapply(x$uri, function(uri) httr::parse_url(uri)$hostname))), 1)
  vcr::use_cassette("get_public_timeline_anonymous", {
    x <- get_public_timeline(instance = "mastodon.social", anonymous = TRUE, token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x)) ## we can't test because it can contain statuses from another instance
})
