test_that("get_list_timeline", {
  vcr::use_cassette("get_list_timeline_default", {
    x <- get_list_timeline(list_id = "2507", limit = 5, parse = TRUE)
  })
  expect_true(nrow(x) == 5)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_list_timeline_noparse", {
    x <- get_list_timeline(list_id = "2507", limit = 5, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
})
