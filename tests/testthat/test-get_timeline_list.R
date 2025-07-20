fake_token <- rtoot:::get_token_from_envvar(
  "RTOOT_DEFAULT_TOKEN",
  check_stop = FALSE
)
fake_token$type <- "user"
fake_token$instance <- "fosstodon.org"

test_that("get_timeline_list", {
  vcr::use_cassette("get_timeline_list_default", {
    x <- get_timeline_list(
      list_id = "7351",
      limit = 5,
      parse = TRUE,
      token = fake_token
    )
  })
  expect_true(nrow(x) == 4)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_list_noparse", {
    x <- get_timeline_list(
      list_id = "7351",
      limit = 5,
      parse = FALSE,
      token = fake_token
    )
  })
  expect_false("tbl_df" %in% class(x))
})
