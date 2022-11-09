## tests for all instance functions

##test_that("get_fedi_instances", {
  ## can't use vcr to test because it doesn't use httr
  ##skip_on_cran()
  ##skip_on_ci()
  ## x <- get_fedi_instances()
  ## expect_true(nrow(x) > 0)
  ## expect_true("data.frame" %in% class(x))
  ## ## #29
  ## x <- get_fedi_instances(n = 22)
  ## expect_true(nrow(x) > 20)
  ## expect_true("data.frame" %in% class(x))
##})

test_that("get_instance_general", {
  vcr::use_cassette("get_instance_general_default", {
    x <- get_instance_general(instance = "mastodon.hk")
  })
  expect_equal(x$uri, "mastodon.hk")
  vcr::use_cassette("get_instance_general_anonymous_false", {
    x <- get_instance_general(instance = "social.tchncs.de", anonymous = FALSE)
  })
  expect_equal(x$uri, "social.tchncs.de")
})

test_that("get_instance_peers", {
  vcr::use_cassette("get_instance_peers_default", {
    x <- get_instance_peers(instance = "mastodon.hk")
  })
  expect_true(length(x) != 0)
  vcr::use_cassette("get_instance_peers_anonymous_false", {
    x <- get_instance_peers(instance = "social.tchncs.de", anonymous = FALSE)
  })
  expect_true(length(x) != 0)
})

test_that("get_instance_activity", {
  vcr::use_cassette("get_instance_activity_default", {
    x <- get_instance_activity(instance = "social.tchncs.de")
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_instance_activity_anonymous_false", {
    x <- get_instance_activity(instance = "social.tchncs.de", anonymous = FALSE)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
})

test_that("get_instance_emoji", {
  vcr::use_cassette("get_instance_emoji_default", {
    x <- get_instance_emoji(instance = "social.tchncs.de")
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_instance_emoji_anonymous_false", {
    x <- get_instance_emoji(instance = "social.tchncs.de", anonymous = FALSE)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
})

test_that("get_instance_directory", {
  ## CHANGE ME AFTER ADDING PARSING
  vcr::use_cassette("get_instance_directory_default", {
    x <- get_instance_directory(instance = "mastodon.social", limit = 3)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_instance_directory_anonymous_false", {
    x <- get_instance_directory(instance = "social.tchncs.de", anonymous = FALSE, limit = 3)
  })
  expect_false("tbl_df" %in% class(x))
})

test_that("get_instance_trends", {
  vcr::use_cassette("get_instance_trends_default", {
    x <- get_instance_trends(instance = "social.tchncs.de")
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_instance_trends_anonymous_false", {
    x <- get_instance_trends(instance = "social.tchncs.de", anonymous = FALSE)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
})
