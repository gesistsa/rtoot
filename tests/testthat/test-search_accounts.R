test_that("search_accounts", {
  vcr::use_cassette("search_accounts_default", {
    x <- search_accounts(query = "chainsawriot")
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("search_accounts_noparse", {
    x <- search_accounts(query = "Kudusch", parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
  ## Most instances won't allow anonymous search; so don't test
  ## vcr::use_cassette("search_accounts_instance", {
  ##   x <- search_accounts(query = "gargron", limit = 1, instance = "mastodon.social")
  ## })
  ## expect_true("tbl_df" %in% class(x))
  ## expect_true(nrow(x) != 0)
  ## vcr::use_cassette("search_accounts_anonymous", {
  ##   x <- search_accounts(query = "gargron", limit = 1, instance = "mastodon.social", anonymous = TRUE)
  ## })
  ## expect_true("tbl_df" %in% class(x))
  ## expect_true(nrow(x) != 0)
})
