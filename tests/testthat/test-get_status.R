fake_token <- rtoot:::get_token_from_envvar(
  "RTOOT_DEFAULT_TOKEN",
  check_stop = FALSE
)
fake_token$type <- "user"
fake_token$instance <- "fosstodon.org"

test_that("get_status", {
  vcr::use_cassette("get_status_default", {
    id <- "114620457512351116"
    x <- get_status(id = id, token = fake_token)
  })
  expect_true("tbl_df" %in% class(x))
  expect_equal(x$id, id)
  vcr::use_cassette("get_status_noparse", {
    id <- "114620457512351116"
    x <- get_status(id = id, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  expect_equal(x$id, id)
  vcr::use_cassette("get_status_instance", {
    id <- "114620457512351116"
    x <- get_status(id = id, instance = "fosstodon.org", token = fake_token)
  })
  expect_true("tbl_df" %in% class(x))
  expect_equal(x$id, id)
  vcr::use_cassette("get_status_anonymous", {
    id <- "114620457512351116"
    x <- get_status(
      id = id,
      instance = "fosstodon.org",
      anonymous = TRUE,
      token = fake_token
    )
  })
  expect_true("tbl_df" %in% class(x))
  expect_equal(x$id, id)
})
