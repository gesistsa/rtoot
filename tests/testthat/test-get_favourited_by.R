test_that("get_favourited_by", {
  vcr::use_cassette("get_favourited_by_default", {
    id <- "109294719267373593"
    x <- get_favourited_by(id = id, instance = "mastodon.social")
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("get_favourited_by_noparse", {
    id <- "109294719267373593"
    x <- get_favourited_by(id = id, instance = "mastodon.social", parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_favourited_by_anonymous", {
    id <- "109294719267373593"
    x <- get_favourited_by(id = id, instance = "mastodon.social", anonymous = TRUE)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("get_favourited_with_token", {
    id <- "109303266941599451"
    x <- get_favourited_by(id = id)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
})
