fake_token <- rtoot:::get_token_from_envvar(
  "RTOOT_DEFAULT_TOKEN",
  check_stop = FALSE
)
fake_token$type <- "user"
fake_token$instance <- "fosstodon.org"

test_that("get_timeline_home", {
  vcr::use_cassette("get_timeline_home_default", {
    x <- get_timeline_home(limit = 5, parse = TRUE, token = fake_token)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_home_noparse", {
    x <- get_timeline_home(limit = 5, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  ## won't do much. ?really working at the API
  vcr::use_cassette("get_timeline_home_local", {
    y <- get_timeline_home(
      local = TRUE,
      limit = 5,
      parse = TRUE,
      token = fake_token
    )
  })
  expect_true(nrow(y) == 5)
  expect_true("tbl_df" %in% class(y))
})
