fake_token <- list(bearer = Sys.getenv("RTOOT_DEFAULT_TOKEN"))
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"
class(fake_token) <- "rtoot_bearer"

test_that("get_timeline_hashtag", {
  vcr::use_cassette("get_timeline_hashtag_default", {
    x <- get_timeline_hashtag(hashtag = "#ichbinhanna", limit = 5, token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_hashtag_default_nohash", {
    x <- get_timeline_hashtag(hashtag = "ichbinhanna", limit = 5, token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_hashtag_default_noparse", {
    x <- get_timeline_hashtag(hashtag = "ichbinhanna", limit = 5, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_hashtag_instance", {
    x <- get_timeline_hashtag(hashtag = "ichbinhanna", limit = 5, instance = "mastodon.social", token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_hashtag_anonymous", {
    x <- get_timeline_hashtag(hashtag = "ichbinhanna", limit = 5, instance = "mastodon.social", anonymous = TRUE, token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
})
