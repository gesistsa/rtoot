fake_token <- rtoot:::get_token_from_envvar(
  "RTOOT_DEFAULT_TOKEN",
  check_stop = FALSE
)
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"

test_that("get_timeline_list", {
  vcr::use_cassette("get_timeline_list_default", {
    x <- get_timeline_list(
      list_id = "2507",
      limit = 5,
      parse = TRUE,
      token = fake_token
    )
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_list_noparse", {
    x <- get_timeline_list(
      list_id = "2507",
      limit = 5,
      parse = FALSE,
      token = fake_token
    )
  })
  expect_false("tbl_df" %in% class(x))
})
