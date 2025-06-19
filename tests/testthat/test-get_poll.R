fake_token <- rtoot:::get_token_from_envvar(
  "RTOOT_DEFAULT_TOKEN",
  check_stop = FALSE
)
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"

test_that("get_poll", {
  vcr::use_cassette("get_poll_default", {
    id <- "105976"
    x <- get_poll(id = id, token = fake_token)
  })
  expect_equal(x$id, id)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_poll_noparse", {
    id <- "105976"
    x <- get_poll(id = id, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_poll_instance", {
    id <- "286799"
    x <- get_poll(id = id, instance = "mastodon.social", token = fake_token)
  })
  expect_equal(x$id, id)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_poll_anonymous", {
    id <- "286799"
    x <- get_poll(
      id = id,
      instance = "mastodon.social",
      anonymous = TRUE,
      token = fake_token
    )
  })
  expect_equal(x$id, id)
  expect_true("tbl_df" %in% class(x))
})
