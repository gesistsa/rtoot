## process_request will only emit messages when rate limit is reached.
## can't test here

fake_token <- rtoot:::get_token_from_envvar(
  "RTOOT_DEFAULT_TOKEN",
  check_stop = FALSE
)
fake_token$type <- "user"
fake_token$instance <- "fosstodon.org"

test_that("process_request: n > page_size", {
  path = "/api/v1/timelines/public"
  n <- 20
  page_size <- 10
  params <- list(
    local = FALSE,
    remote = FALSE,
    only_media = FALSE,
    limit = page_size
  )
  vcr::use_cassette("process_request_bigger", {
    x <- process_request(
      token = fake_token,
      params = params,
      path = path,
      page_size = page_size,
      n = n,
      verbose = FALSE,
      FUN = v(parse_status)
    )
  })
  expect_true(nrow(x) >= n)
})

test_that("process_request: n < page_size", {
  path = "/api/v1/timelines/public"
  n <- 10
  page_size <- 20
  params <- list(
    local = FALSE,
    remote = FALSE,
    only_media = FALSE,
    limit = page_size
  )
  vcr::use_cassette("process_request_smaller", {
    x <- process_request(
      token = fake_token,
      params = params,
      path = path,
      page_size = page_size,
      n = n,
      verbose = FALSE,
      FUN = v(parse_status)
    )
  })
  expect_true(nrow(x) >= n)
})

test_that("process_request: n == page_size, and page_size is lower than API limit", {
  path = "/api/v1/timelines/public"
  n <- 20
  page_size <- 20
  params <- list(
    local = FALSE,
    remote = FALSE,
    only_media = FALSE,
    limit = page_size
  )
  vcr::use_cassette("process_request_equal1", {
    x <- process_request(
      token = fake_token,
      params = params,
      path = path,
      page_size = page_size,
      n = n,
      verbose = FALSE,
      FUN = v(parse_status)
    )
  })
  expect_true(nrow(x) == n)
})

## This has been controlled by the applying functions.
## e.g.  params <- list(limit = min(limit,40L))

## test_that("process_request: n == page_size, and page_size is higher than API limit", {
##   path = "/api/v1/timelines/public"
##   n <- 50
##   page_size <- 50
##   params <- list(local = FALSE, remote = FALSE, only_media = FALSE, limit = page_size)
##   vcr::use_cassette("process_request_equal2", {
##     x <- process_request(token = fake_token, params = params, path = path, page_size = page_size,
##                          n = n, verbose = FALSE, FUN = v(parse_status))
##   })
##   expect_true(nrow(x) == n)
## })
