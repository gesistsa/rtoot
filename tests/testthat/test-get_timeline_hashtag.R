test_that("get_timeline_hashtag", {
  vcr::use_cassette("get_timeline_hashtag_default", {
    x <- get_timeline_hashtag(hashtag = "#ichbinhanna", limit = 5)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_hashtag_default_nohash", {
    x <- get_timeline_hashtag(hashtag = "ichbinhanna", limit = 5)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_hashtag_default_noparse", {
    x <- get_timeline_hashtag(hashtag = "ichbinhanna", limit = 5, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_hashtag_instance", {
    x <- get_timeline_hashtag(hashtag = "ichbinhanna", limit = 5, instance = "mastodon.social")
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_hashtag_anonymous", {
    x <- get_timeline_hashtag(hashtag = "ichbinhanna", limit = 5, instance = "mastodon.social", anonymous = TRUE)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
})
