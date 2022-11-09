fake_token <- list(bearer = Sys.getenv("RTOOT_DEFAULT_TOKEN"))
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"
class(fake_token) <- "rtoot_bearer"

test_that("get_hashtag_timeline", {
  vcr::use_cassette("get_hashtag_timeline_default", {
    x <- get_hashtag_timeline(hashtag = "#ichbinhanna", limit = 5, token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_hashtag_timeline_default_nohash", {
    x <- get_hashtag_timeline(hashtag = "ichbinhanna", limit = 5, token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_hashtag_timeline_default_noparse", {
    x <- get_hashtag_timeline(hashtag = "ichbinhanna", limit = 5, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_hashtag_timeline_instance", {
    x <- get_hashtag_timeline(hashtag = "ichbinhanna", limit = 5, instance = "mastodon.social", token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_hashtag_timeline_anonymous", {
    x <- get_hashtag_timeline(hashtag = "ichbinhanna", limit = 5, instance = "mastodon.social", anonymous = TRUE, token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
})
