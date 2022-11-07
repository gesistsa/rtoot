empty <- data.frame(id = NA_character_, uri = NA_character_, created_at = NA_character_, content = NA_character_, visibility = NA_character_, sensitive = NA, spoiler_text = NA_character_, reblogs_count = 0, favourites_count = 0, replies_count = 0, url = NA_character_, in_reply_to_id = NA_character_, in_reply_to_account_id = NA_character_, language = NA_character_, text = NA_character_, application = I(list(list())), poll = I(list(list())), card = I(list(list())), account = I(list(list())), reblog = I(list(list())), media_attachments = I(list(list())), mentions = I(list(list())), tags = I(list(list())), emojis = I(list(list())), favourited = NA, reblogged = NA, muted = NA, bookmarked = NA, pinned = NA)

test_that("status is NULL", {
  expect_equal(parse_status(NULL, as_tibble = FALSE), empty)
  expect_true("tbl_df" %in% class(parse_status(NULL)))
})

test_that("simplest cases", {
  status <- readRDS("../testdata/status/not_reblog.RDS")
  expect_error(parse_status(status, as_tibble = FALSE), NA)
  expect_error(parse_status(status, as_tibble = TRUE), NA)
  res <- parse_status(status, as_tibble = FALSE)
  expect_equal(colnames(empty), colnames(res))
})

test_that("With media attachments", {
  status <- readRDS("../testdata/status/single_media_attachment.RDS")
  expect_error(parse_status(status, as_tibble = FALSE), NA)
  expect_error(parse_status(status, as_tibble = TRUE), NA)
  res <- parse_status(status, as_tibble = FALSE)
  expect_equal(colnames(empty), colnames(res))
  expect_equal(length(res$media_attachments), 1)
  expect_equal(res$media_attachments[[1]]$type, "image")
})

test_that("With and without personal fields", {
  status1 <- readRDS("../testdata/status/not_reblog.RDS")
  status2 <- readRDS("../testdata/status/single_media_attachment.RDS")
  res1 <- parse_status(status1)
  res2 <- parse_status(status2)
  expect_true(is.na(res1$favourited))
  expect_true(is.na(res1$reblogged))
  expect_true(is.na(res1$muted))
  expect_true(is.na(res1$bookmarked))
  expect_true(is.na(res1$pinned))
  expect_true(!is.na(res2$favourited))
  expect_true(!is.na(res2$reblogged))
  expect_true(!is.na(res2$muted))
  expect_true(!is.na(res2$bookmarked))
  expect_true(!is.na(res2$pinned))
})

test_that("With and without poll", {
  status1 <- readRDS("../testdata/status/not_reblog.RDS")
  status2 <- readRDS("../testdata/status/poll.RDS")
  res1 <- parse_status(status1)
  res2 <- parse_status(status2)
  expect_equal(length(res1$poll[[1]]), 0)
  expect_false(length(res2$poll[[1]]) == 0)
})

test_that("Is and Isn't reblog", {
  status1 <- readRDS("../testdata/status/not_reblog.RDS")
  status2 <- readRDS("../testdata/status/reblog.RDS")
  res1 <- parse_status(status1)
  res2 <- parse_status(status2)
  expect_equal(length(res1$reblog[[1]]), 0)
  expect_false(length(res2$reblog[[1]]) == 0)
  expect_equal(res2$reblog[[1]]$account[[1]]$username, "JBGruber")
})
