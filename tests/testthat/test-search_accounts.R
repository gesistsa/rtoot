fake_token <- rtoot:::get_token_from_envvar("RTOOT_DEFAULT_TOKEN", check_stop = FALSE)
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"

test_that("search_accounts", {
  vcr::use_cassette("search_accounts_default", {
    x <- search_accounts(query = "chainsawriot", token = fake_token)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("search_accounts_noparse", {
    x <- search_accounts(query = "Kudusch", parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
})

fake_token <- rtoot:::get_token_from_envvar("RTOOT_DEFAULT_TOKEN", check_stop = FALSE)
fake_token$type <- "user"
fake_token$instance <- "emacs"

## #105 https://github.com/schochastics/rtoot/issues/105
test_that("search_accounts without instance", {
  expect_error(search_accounts(query = "chainsawriot", token = fake_token, instance = "emacs.ch"), regexp = "unused argument")
})
