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
