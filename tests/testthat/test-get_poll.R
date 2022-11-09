test_that("get_poll", {
  vcr::use_cassette("get_poll_default", {
    id <- "105976"
    x <- get_poll(id = id)
  })
  expect_equal(x$id, id)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_poll_noparse", {
    id <- "105976"
    x <- get_poll(id = id, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_poll_instance", {
    id <- "286799"
    x <- get_poll(id = id, instance = "mastodon.social")
  })
  expect_equal(x$id, id)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_poll_anonymous", {
    id <- "286799"
    x <- get_poll(id = id, instance = "mastodon.social", anonymous = TRUE)
  })
  expect_equal(x$id, id)
  expect_true("tbl_df" %in% class(x))
})
