fake_token <- list(bearer = Sys.getenv("RTOOT_DEFAULT_TOKEN"))
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"
class(fake_token) <- "rtoot_bearer"

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
