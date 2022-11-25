fake_token <- rtoot:::get_token_from_envvar("RTOOT_DEFAULT_TOKEN", check_stop = FALSE)
fake_token$type <- "user"
fake_token$instance <- "emacs.ch"


test_that("defensive", {
  expect_error(stream_timeline_public(anonymous = TRUE, verbose = FALSE))
  expect_error(stream_timeline_hashtag(anonymous = TRUE, verbose = FALSE))
  expect_error(stream_timeline_list(anonymous = TRUE, verbose = FALSE))
  expect_error(stream_timeline_public(anonymous = TRUE, instance = "emacs.ch", timeout = -10, verbose = FALSE))
  expect_error(stream_timeline_public(anonymous = TRUE, instance = "emacs.ch", timeout = "elon", verbose = FALSE))
})

test_that("stream, when append=TRUE", {
  skip_on_ci()
  skip_if_offline()
  skip_if(Sys.getenv("RTOOT_TEST_STREAM") != "yes")
  tmp_file <- tempfile(fileext = ".json")
  expect_false(file.exists(tmp_file))
  stream_timeline_public(timeout = 2, file_name = tmp_file, token = fake_token, instance = "fosstodon.org", verbose = FALSE, append = TRUE)
  expect_true(file.exists(tmp_file))
  first_n <- nrow(parse_stream(tmp_file))
  expect_true(first_n > 0)
  stream_timeline_public(timeout = 2, file_name = tmp_file, token = fake_token, instance = "fosstodon.org", verbose = FALSE, append = TRUE)
  second_n <- nrow(parse_stream(tmp_file))
  expect_true(second_n > first_n)
  unlink(tmp_file)
})

test_that("stream, when append=FALSE", {
  skip_on_ci()
  skip_if_offline()
  skip_if(Sys.getenv("RTOOT_TEST_STREAM") != "yes")
  tmp_file <- tempfile(fileext = ".json")
  expect_false(file.exists(tmp_file))
  ## #96
  expect_error(stream_timeline_public(timeout = 2, file_name = tmp_file, token = fake_token, instance = "fosstodon.org", verbose = FALSE, append = FALSE), NA)
  expect_true(file.exists(tmp_file))
  first_batch <- parse_stream(tmp_file)
  first_n <- nrow(first_batch)
  expect_true(first_n > 0)
  stream_timeline_public(timeout = 2, file_name = tmp_file, token = fake_token, instance = "fosstodon.org", verbose = FALSE, append = FALSE)
  second_batch <- parse_stream(tmp_file)
  expect_false(any(first_batch$id %in% second_batch$id))
  unlink(tmp_file)
})

test_that("parse_stream", {
  expect_error(x <- parse_stream("../testdata/mastodonsocial.json"), NA)
  expect_equal(48, nrow(x))
  expect_true("tbl_df" %in% class(x))
  ## corner case
  tmp <- tempfile(fileext = ".json")
  z <- file.create(tmp)
  expect_error(x <- parse_stream(tmp), NA)
  expect_equal(0, nrow(x))
  expect_true("tbl_df" %in% class(x))
})

test_that("parse_stream_malformed", {
  ## issue 108
  skip_if(!file.exists("../testdata/malformed.json"))
  raw <- readLines("../testdata/malformed.json")
  expect_equal(50, length(raw))
  expect_error(x <- parse_stream("../testdata/malformed.json"), NA)
  expect_equal(49, nrow(x))
})
