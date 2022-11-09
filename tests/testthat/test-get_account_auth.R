## tests for all "get_account_*" functions that require a user token
## get_account_followers, get_account_following, get_account_featured_tags,
## get_account_lists, get_account_relationships,get_account_bookmarks,
## get_account_favourites, get_account_blocks,
## get_account_mutes

id <- "109281650341067731"

## These have a meaningful parse parameter, so need to test `noparse`

test_that("get_account_followers", {
  vcr::use_cassette("get_account_followers_default", {
    x <- get_account_followers(id = id, limit = 3)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("get_account_followers_noparse", {
    x <- get_account_followers(id = id, limit = 3, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
})

test_that("get_account_following", {
  vcr::use_cassette("get_account_following_default", {
    x <- get_account_following(id = id, limit = 3)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("get_account_following_noparse", {
    x <- get_account_following(id = id, limit = 3, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
})

test_that("get_account_bookmarks", {
  vcr::use_cassette("get_account_bookmarks_default", {
    x <- get_account_bookmarks(limit = 3)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("get_account_bookmarks_noparse", {
    x <- get_account_bookmarks(limit = 3, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
})

test_that("get_account_favourites", {
  vcr::use_cassette("get_account_favourites_default", {
    x <- get_account_favourites(limit = 3)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("get_account_favourites_noparse", {
    x <- get_account_favourites(limit = 3, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
})

test_that("get_account_blocks", {
  ## sorry rfortunes, you get blocked for science
  vcr::use_cassette("get_account_blocks_default", {
    x <- get_account_blocks(limit = 3)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("get_account_blocks_noparse", {
    x <- get_account_blocks(limit = 3, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
})

test_that("get_account_mutes", {
  ## sorry rfortunes, you get muted for science too
  vcr::use_cassette("get_account_mutes_default", {
    x <- get_account_mutes(limit = 3)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("get_account_mutes_noparse", {
    x <- get_account_mutes(limit = 3, parse = FALSE)
  })
  expect_false("tbl_df" %in% class(x))
})

## no meaningful parse parameter; no need to test noparse
test_that("get_account_featured_tags", {
  vcr::use_cassette("get_account_featured_tags_default", {
    x <- get_account_featured_tags(id = id)
  })
  expect_true("tbl_df" %in% class(x))
})

test_that("get_account_lists", {
  vcr::use_cassette("get_account_lists_default", {
    x <- get_account_lists(id = id)
  })
  expect_true("tbl_df" %in% class(x))
})

test_that("get_account_relationships", {
  vcr::use_cassette("get_account_relationships_default", {
    x <- get_account_relationships(id = id)
  })
  expect_true("tbl_df" %in% class(x))
})
