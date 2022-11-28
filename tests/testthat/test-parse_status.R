empty <- tibble::tibble(id = NA_character_, uri = NA_character_, created_at = NA_character_, content = NA_character_, visibility = NA_character_, sensitive = NA, spoiler_text = NA_character_, reblogs_count = 0, favourites_count = 0, replies_count = 0, url = NA_character_, in_reply_to_id = NA_character_, in_reply_to_account_id = NA_character_, language = NA_character_, text = NA_character_, application = I(list(list())), poll = I(list(list())), card = I(list(list())), account = I(list(list())), reblog = I(list(list())), media_attachments = I(list(list())), mentions = I(list(list())), tags = I(list(list())), emojis = I(list(list())), favourited = NA, reblogged = NA, muted = NA, bookmarked = NA, pinned = NA)

test_that("status is NULL", {
  expect_equal(parse_status(NULL), empty)
  expect_true("tbl_df" %in% class(parse_status(NULL)))
})

test_that("simplest cases", {
  status <- readRDS("../testdata/status/not_reblog.RDS")
  expect_error(parse_status(status), NA)
  res <- parse_status(status)
  expect_equal(colnames(empty), colnames(res))
})

test_that("With media attachments", {
  status <- readRDS("../testdata/status/single_media_attachment.RDS")
  expect_error(parse_status(status), NA)
  res <- parse_status(status)
  expect_equal(colnames(empty), colnames(res))
  expect_equal(length(res$media_attachments), 1)
  expect_equal(res$media_attachments[[1]]$type[1], "image")
  expect_equal(length(res$media_attachments[[1]]$type), 2)
  expect_true("tbl_df" %in% class(res$media_attachments[[1]]))
})

test_that("With tags", {
  status <- readRDS("../testdata/status/multi_tags.RDS")
  expect_error(res <- parse_status(status), NA)
  expect_equal(nrow(res$tags[[1]]), 4)
  expect_true("tbl_df" %in% class(res$tags[[1]]))
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

test_that("parse_poll", {
  status <- readRDS("../testdata/status/poll.RDS")
  empty_poll<- tibble::tibble(
                         id = NA_character_, expires_at = NA_character_,
                         expired = NA, multiple = NA,
                         votes_count = NA, voters_count = NA,
                         voted = NA, own_votes = I(list(list())),
                         options = I(list(list())),
                         emojis = I(list(list())))
  expect_equal(parse_poll(NULL), empty_poll)
  expect_true("tbl_df" %in% class(parse_status(NULL)))
  expect_error(parse_poll(status$poll), NA)
  expect_equal(colnames(empty_poll), colnames(parse_poll(status$poll)))
})

test_that("With and without poll", {
  empty_poll<- tibble::tibble(
                         id = NA_character_, expires_at = NA_character_,
                         expired = NA, multiple = NA,
                         votes_count = NA, voters_count = NA,
                         voted = NA, own_votes = I(list(list())),
                         options = I(list(list())),
                         emojis = I(list(list())))
  status1 <- readRDS("../testdata/status/not_reblog.RDS")
  status2 <- readRDS("../testdata/status/poll.RDS")
  res1 <- parse_status(status1)
  res2 <- parse_status(status2)
  expect_equal(length(res1$poll[[1]]), 0)
  expect_false(length(res2$poll[[1]]) == 0)
  expect_equal(colnames(res2$poll[[1]]), colnames(empty_poll))
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

test_that("date parsing", {
  status1 <- readRDS("../testdata/status/not_reblog.RDS")
  res1 <- parse_status(status1, parse_date = TRUE)
  res2 <- parse_status(status1, parse_date = FALSE)
  expect_true("POSIXlt" %in% class(res1$created_at))
  expect_false("POSIXlt" %in% class(res2$created_at))
})

test_that("poll parsing with own_votes, issue #115", {
  poll <- list(id = "615", expires_at = "2022-11-27T11:06:56.000Z", expired = TRUE, 
               multiple = TRUE, votes_count = 86L, voters_count = 84L, voted = TRUE, 
               own_votes = list(0L), options = list(list(title = "mu4e", 
                                                         votes_count = 50L),
                                                    list(title = "notmuch", votes_count = 20L), 
                                                    list(title = "gnus", votes_count = 13L),
                                                    list(title = "other (please comment)", 
                                                         votes_count = 3L)),
               emojis = list())
  expect_error(parse_poll(poll), NA)
  poll$own_votes <- list()
  expect_error(parse_poll(poll), NA)
  ## integration test
  timeline <- readRDS("../testdata/timeline/timeline_with_poll115.RDS")
  expect_error(s <- parse_status(timeline[[20]]), NA)
  expect_equal(s$poll[[1]]$own_votes[[1]][[1]], 0)
  expect_error(v(parse_status)(timeline), NA)
})
