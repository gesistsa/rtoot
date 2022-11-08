test_that("get_status", {
  vcr::use_cassette("get_status_default", {
    id <- "109298295023649405"
    x <- get_status(id = id)
  })
  expect_true("tbl_df" %in% class(x))
  expect_equal(x$id, id)
  vcr::use_cassette("get_status_noparse", {
    id <- "109298295023649405"
    x <- get_status(id = id, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
  expect_equal(x$id, id)
  vcr::use_cassette("get_status_instance", {
    id <- "109294719267373593"
    x <- get_status(id = id, instance = "mastodon.social")
  })
  expect_true("tbl_df" %in% class(x))
  expect_equal(x$id, id)
  vcr::use_cassette("get_status_anonymous", {
    id <- "109294719267373593"
    x <- get_status(id = id, instance = "mastodon.social", anonymous = TRUE)
  })
  expect_true("tbl_df" %in% class(x))
  expect_equal(x$id, id)
})
