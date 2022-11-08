test_that("get_account", {
  vcr::use_cassette("get_account_default", {
    id <- "109281650341067731"
    x <- get_account(id = id)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  expect_equal(id, x$id)
  vcr::use_cassette("get_account_noparse", {
    id <- "109281650341067731"
    x <- get_account(id = id, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
  expect_equal(id, x$id)
})
