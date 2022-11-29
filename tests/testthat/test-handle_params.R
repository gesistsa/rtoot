test_that("handle_params", {
  expect_equal(handle_params(list()), list())
  x <- handle_params(list(hello = "world"), max_id = 1)
  expect_equal(x$hello, "world")
  expect_equal(x$max_id, 1)
  x <- handle_params(list(hello = "world"), max_id = 1, since_id = 2)
  expect_equal(x$hello, "world")
  expect_equal(x$max_id, 1)
  expect_equal(x$since_id, 2)
  x <- handle_params(list(hello = "world"), max_id = 1, min_id = 3)
  expect_equal(x$hello, "world")
  expect_equal(x$max_id, 1)
  expect_equal(x$min_id, 3)
  expect_null(x$since_id)
  ## positional
  x <- handle_params(list(hello = "world"), 1, 2)
  expect_equal(x$hello, "world")
  expect_equal(x$max_id, 1)
  expect_equal(x$since_id, 2)
  expect_null(x$min_id)
  x <- handle_params(list(hello = "world"), 1, 2, 3)
  expect_equal(x$hello, "world")
  expect_equal(x$max_id, 1)
  expect_equal(x$since_id, 2)
  expect_equal(x$min_id, 3)
})

test_that("integration test", {
  ## The old wiki example; it use max_id
  vcr::use_cassette("handle_params_max_id", {
  max_id <- NULL
  output <- tibble::tibble()
  for (i in 1:4) {
    res <- get_timeline_hashtag(hashtag = "ichbinhanna", max_id = max_id,
                                limit = 40, instance = "mastodon.social",
                                anonymous = TRUE)
    output <- rbind(res, output)
    max_id <- res$id[res$created_at == min(res$created_at)]
    Sys.sleep(1)
  }
  })
  expect_equal(nrow(output), 160)
  expect_equal(length(unique(output$id)), 160) ## all unique
})
