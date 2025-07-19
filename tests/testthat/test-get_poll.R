fake_token <- rtoot:::get_token_from_envvar(
  "RTOOT_DEFAULT_TOKEN",
  check_stop = FALSE
)
fake_token$type <- "user"
fake_token$instance <- "fosstodon.org"

test_that("get_poll", {
  vcr::use_cassette("get_poll_default", {
    id <- "684128"
    x <- get_poll(id = id, token = fake_token)
  })
  expect_equal(x$id, id)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_poll_noparse", {
    id <- "684128"
    x <- get_poll(id = id, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_poll_instance", {
    id <- "684128"
    x <- get_poll(id = id, instance = "fosstodon.org", token = fake_token)
  })
  expect_equal(x$id, id)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_poll_anonymous", {
    id <- "684128"
    x <- get_poll(
      id = id,
      instance = "fosstodon.org",
      anonymous = TRUE,
      token = fake_token
    )
  })
  expect_equal(x$id, id)
  expect_true("tbl_df" %in% class(x))
})
