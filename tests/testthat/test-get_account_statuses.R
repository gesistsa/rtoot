fake_token <- rtoot:::get_token_from_envvar("RTOOT_DEFAULT_TOKEN", check_stop = FALSE)
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"

test_that("get_account_statuses", {
  vcr::use_cassette("get_account_statuses_default", {
    id <- "109281650341067731"
    x <- get_account_statuses(id = id, token = fake_token)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("get_account_statuses_noparse", {
    id <- "109281650341067731"
    x <- get_account_statuses(id = id, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  ## Doesn't test instance and anonymous; see test_search_accounts.R
})

test_that("get_account_statuses, limit", {
  ## whether it can flip pages
  vcr::use_cassette("get_account_statuses_limit", {
    id <- "109281650341067731"
    x <- get_account_statuses(id = id, instance = "social.tchncs.de", limit = 100, token = fake_token)
  })
  expect_true(nrow(x) > 40) # it should have 43
  expect_true("tbl_df" %in% class(x))
})
