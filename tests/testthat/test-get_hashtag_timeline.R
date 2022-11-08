test_that("get_hashtag_timeline", {
  vcr::use_cassette("get_hashtag_timeline_default", {
    x <- get_hashtag_timeline(hashtag = "#ichbinhanna", limit = 5)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_hashtag_timeline_default_nohash", {
    x <- get_hashtag_timeline(hashtag = "ichbinhanna", limit = 5)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_hashtag_timeline_default_noparse", {
    x <- get_hashtag_timeline(hashtag = "ichbinhanna", limit = 5, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_hashtag_timeline_instance", {
    x <- get_hashtag_timeline(hashtag = "ichbinhanna", limit = 5, instance = "mastodon.social")
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_hashtag_timeline_anonymous", {
    x <- get_hashtag_timeline(hashtag = "ichbinhanna", limit = 5, instance = "mastodon.social", anonymous = TRUE)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
})
