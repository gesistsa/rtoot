fake_token <- rtoot:::get_token_from_envvar(
  "RTOOT_DEFAULT_TOKEN",
  check_stop = FALSE
)
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"

test_that("get_timeline_public", {
  vcr::use_cassette("get_timeline_public_default", {
    x <- get_timeline_public(token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_public_notparse", {
    x <- get_timeline_public(parse = FALSE, token = fake_token)
  })
  expect_false("tbl_df" %in% class(x))
  vcr::use_cassette("get_timeline_public_instance", {
    x <- get_timeline_public(instance = "mastodon.social", token = fake_token)
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x)) ## we can't test because it can contain statuses from another instance
  vcr::use_cassette("get_timeline_public_instance_local", {
    x <- get_timeline_public(local = TRUE, limit = 10, token = fake_token)
  })
  ## it should have only one type of hostname
  expect_equal(
    length(unique(sapply(x$uri, function(uri) httr::parse_url(uri)$hostname))),
    1
  )
  vcr::use_cassette("get_timeline_public_anonymous", {
    x <- get_timeline_public(
      instance = "mastodon.social",
      anonymous = TRUE,
      token = fake_token
    )
  })
  expect_true(nrow(x) != 0)
  expect_true("tbl_df" %in% class(x)) ## we can't test because it can contain statuses from another instance
})
