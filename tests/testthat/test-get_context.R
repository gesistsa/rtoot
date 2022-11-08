test_that("get_context", {
  vcr::use_cassette("get_context_default", {
    id <- "109294719267373593"
    x <- get_context(id = id, instance = "mastodon.social")
  })
  expect_equal(class(x), "list")
  expect_true("tbl_df" %in% class(x$ancestors))
  expect_true("tbl_df" %in% class(x$descendants))
  expect_equal(nrow(x$ancestors), 0)
  expect_false(nrow(x$descendants) == 0)
  vcr::use_cassette("get_context_noparse", {
    id <- "109294719267373593"
    x <- get_context(id = id, instance = "mastodon.social", parse = FALSE)
  })
  expect_equal(class(x), "list")
  expect_false("tbl_df" %in% class(x$ancestors))
  expect_false("tbl_df" %in% class(x$descendants))
  vcr::use_cassette("get_context_anonymous", {
    id <- "109294719267373593"
    x <- get_context(id = id, instance = "mastodon.social", anonymous = FALSE)
  })
  expect_equal(class(x), "list")
  expect_true("tbl_df" %in% class(x$ancestors))
  expect_true("tbl_df" %in% class(x$descendants))
  expect_equal(nrow(x$ancestors), 0)
  expect_false(nrow(x$descendants) == 0)
  vcr::use_cassette("get_context_with_token", {
    id <- "109303266941599451"
    x <- get_context(id = id)
  })
  expect_equal(class(x), "list")
  expect_true("tbl_df" %in% class(x$ancestors))
  expect_true("tbl_df" %in% class(x$descendants))
  expect_equal(nrow(x$ancestors), 0)
  expect_false(nrow(x$descendants) == 0)
  vcr::use_cassette("get_context_with_ancesters", {
    id <- "109303309876585639"
    x <- get_context(id = id)
  })
  expect_equal(class(x), "list")
  expect_true("tbl_df" %in% class(x$ancestors))
  expect_true("tbl_df" %in% class(x$descendants))
  expect_true(nrow(x$ancestors) != 0)
  expect_true(nrow(x$descendants) != 0)
  vcr::use_cassette("get_context_without_descendants", {
    id <- "109308119383536793"
    x <- get_context(id = id)
  })
  expect_true("tbl_df" %in% class(x$ancestors))
  expect_true("tbl_df" %in% class(x$descendants))
  expect_true(nrow(x$ancestors) != 0)
  expect_false(nrow(x$descendants) != 0)
})
