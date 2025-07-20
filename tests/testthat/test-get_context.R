fake_token <- rtoot:::get_token_from_envvar(
  "RTOOT_DEFAULT_TOKEN",
  check_stop = FALSE
)
fake_token$type <- "user"
fake_token$instance <- "fosstodon.org"

test_that("get_context", {
  vcr::use_cassette("get_context_default", {
    id <- "109294719267373593"
    x <- get_context(id = id, instance = "mastodon.social", token = fake_token)
  })
  expect_equal(class(x), "list")
  expect_true("tbl_df" %in% class(x$ancestors))
  expect_true("tbl_df" %in% class(x$descendants))
  expect_equal(nrow(x$ancestors), 0)
  expect_false(nrow(x$descendants) == 0)
  vcr::use_cassette("get_context_noparse", {
    id <- "109294719267373593"
    x <- get_context(
      id = id,
      instance = "mastodon.social",
      parse = FALSE,
      token = fake_token
    )
  })
  expect_equal(class(x), "list")
  expect_false("tbl_df" %in% class(x$ancestors))
  expect_false("tbl_df" %in% class(x$descendants))
  vcr::use_cassette("get_context_anonymous", {
    id <- "109294719267373593"
    x <- get_context(
      id = id,
      instance = "mastodon.social",
      anonymous = FALSE,
      token = fake_token
    )
  })
  expect_equal(class(x), "list")
  expect_true("tbl_df" %in% class(x$ancestors))
  expect_true("tbl_df" %in% class(x$descendants))
  expect_equal(nrow(x$ancestors), 0)
  expect_false(nrow(x$descendants) == 0)
  vcr::use_cassette("get_context_with_token", {
    id <- "114026814291152535"
    x <- get_context(id = id, token = fake_token)
  })
  expect_equal(class(x), "list")
  expect_true("tbl_df" %in% class(x$ancestors))
  expect_true("tbl_df" %in% class(x$descendants))
  expect_equal(nrow(x$ancestors), 0)
  expect_false(nrow(x$descendants) == 0)
  vcr::use_cassette("get_context_with_ancesters", {
    id <- "114027213608365869"
    x <- get_context(id = id, token = fake_token)
  })
  expect_equal(class(x), "list")
  expect_true("tbl_df" %in% class(x$ancestors))
  expect_true("tbl_df" %in% class(x$descendants))
  expect_true(nrow(x$ancestors) != 0)
  expect_true(nrow(x$descendants) == 0)
  vcr::use_cassette("get_context_without_descendants", {
    id <- "114027213608365869"
    x <- get_context(id = id, token = fake_token)
  })
  expect_true("tbl_df" %in% class(x$ancestors))
  expect_true("tbl_df" %in% class(x$descendants))
  expect_true(nrow(x$ancestors) != 0)
  expect_false(nrow(x$descendants) != 0)
})
