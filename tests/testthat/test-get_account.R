fake_token <- rtoot:::get_token_from_envvar("RTOOT_DEFAULT_TOKEN", check_stop = FALSE)
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"

test_that("get_account", {
  vcr::use_cassette("get_account_default", {
    id <- "109281650341067731"
    x <- get_account(id = id, token = fake_token)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  expect_equal(id, x$id)
  vcr::use_cassette("get_account_noparse", {
    id <- "109281650341067731"
    x <- get_account(id = id, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  expect_equal(id, x$id)
  ## Doesn't test instance and anonymous; see test_search_accounts.R
})
