## tests for all instance functions
fake_token <- rtoot:::get_token_from_envvar("RTOOT_DEFAULT_TOKEN", check_stop = FALSE)
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"

test_that("get_fedi_instances", {
  vcr::use_cassette("get_fedi_instances_default", {
    x <- get_fedi_instances()
  })
  expect_true(nrow(x) > 0)
  expect_true("tbl_df" %in% class(x))
  ## #29
  vcr::use_cassette("get_fedi_instances_pr29", {
    x <- get_fedi_instances(n = 22)
  })
  expect_true(nrow(x) > 20)
  expect_true("tbl_df" %in% class(x))
})

test_that("get_instance_general", {
  vcr::use_cassette("get_instance_general_default", {
    x <- get_instance_general(instance = "mastodon.hk", token = fake_token)
  })
  expect_equal(x$uri, "mastodon.hk")
  vcr::use_cassette("get_instance_general_anonymous_false", {
    x <- get_instance_general(instance = "social.tchncs.de", anonymous = FALSE, token = fake_token)
  })
  expect_equal(x$uri, "social.tchncs.de")
})

test_that("get_instance_peers", {
  vcr::use_cassette("get_instance_peers_default", {
    x <- get_instance_peers(instance = "mastodon.hk", token = fake_token)
  })
  expect_true(length(x) != 0)
  vcr::use_cassette("get_instance_peers_anonymous_false", {
    x <- get_instance_peers(instance = "social.tchncs.de", anonymous = FALSE, token = fake_token)
  })
  expect_true(length(x) != 0)
})

test_that("get_instance_activity", {
  vcr::use_cassette("get_instance_activity_default", {
    x <- get_instance_activity(instance = "social.tchncs.de", token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_instance_activity_anonymous_false", {
    x <- get_instance_activity(instance = "social.tchncs.de", anonymous = FALSE, token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
})

test_that("get_instance_emoji", {
  vcr::use_cassette("get_instance_emoji_default", {
    x <- get_instance_emoji(instance = "social.tchncs.de", token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_instance_emoji_anonymous_false", {
    x <- get_instance_emoji(instance = "social.tchncs.de", anonymous = FALSE, token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
})

test_that("get_instance_directory", {
  vcr::use_cassette("get_instance_directory_default", {
    x <- get_instance_directory(instance = "mastodon.social", limit = 3, token = fake_token)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
  vcr::use_cassette("get_instance_directory_noparse", {
    x <- get_instance_directory(instance = "mastodon.social", limit = 3, parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_instance_directory_anonymous_false", {
    x <- get_instance_directory(instance = "social.tchncs.de", anonymous = FALSE, limit = 3, token = fake_token)
  })
  expect_true("tbl_df" %in% class(x))
  expect_true(nrow(x) != 0)
})

test_that("get_instance_trends", {
  vcr::use_cassette("get_instance_trends_default", {
    x <- get_instance_trends(instance = "social.tchncs.de", token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_instance_trends_anonymous_false", {
    x <- get_instance_trends(instance = "social.tchncs.de", anonymous = FALSE, token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
})

test_that("get_instance_rules",{
  vcr::use_cassette("get_instance_rules_default",{
    x <- get_instance_rules(instance = "social.tchncs.de", anonymous = TRUE)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
})

test_that("get_instance_blocks",{
  vcr::use_cassette("get_instance_blocks_default",{
    x <- get_instance_blocks(instance = "social.tchncs.de", anonymous = TRUE)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
})
