fake_token <- rtoot:::get_token_from_envvar("RTOOT_DEFAULT_TOKEN", check_stop = FALSE)
fake_token$type <- "user"
fake_token$instance <- "fosstodon.org"

test_that("get_list_accounts", {
  vcr::use_cassette("get_list_accounts", {
    x <- get_list_accounts(id = "7351", limit = 2, parse = TRUE, token = fake_token)
  })
  expect_true(nrow(x) == 2)
  expect_true("tbl_df" %in% class(x))
})

test_that("get_lists", {
  vcr::use_cassette("get_lists", {
    x <- get_lists(id = "7351", parse = TRUE, token = fake_token)
  })
  expect_true(nrow(x) == 1)
  expect_true("tbl_df" %in% class(x))
})
