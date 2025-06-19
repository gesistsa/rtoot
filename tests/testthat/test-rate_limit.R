## wait_until ,rate_limit_remaining and break_process_request

test_that("wait_until", {
  x <- capture_message(wait_until(2, 1, verbose = TRUE))
  expect_true(grepl("1 second", x))
  expect_silent(wait_until(2, 1, verbose = FALSE))
  x <- capture_message(wait_until(3, 1, verbose = TRUE))
  expect_true(grepl("2 second", x))
  added_sec <- 2
  fake_until <- as.character(as.integer(added_sec + unclass(Sys.time())))
  x <- capture_message(wait_until(until = fake_until, verbose = TRUE))
  expect_true(grepl("second", x))
  current_time <- as.character(as.integer(unclass(Sys.time())))
  ## No waiting; so no message
  expect_silent(wait_until(until = current_time, verbose = TRUE))
  expect_silent(wait_until(until = current_time, verbose = FALSE))
})

test_that("rate_limit_remaining", {
  x <- readRDS("../testdata/fake_headers.RDS")
  expect_equal(rate_limit_remaining(x), 299)
  ## tempering
  y <- x
  newheader <- attr(x, "headers")[, c("rate_limit", "rate_reset", "max_id")]
  attr(y, "headers") <- newheader
  expect_warning(rate_limit_remaining(y))
  z <- data.frame(x = c(1, 2, 3, 4))
  expect_error(rate_limit_remaining(z))
})

test_that("break_process_request", {
  ## rate_limit = 299
  x1 <- readRDS("../testdata/fake_headers.RDS")
  expect_false(break_process_request(x1))
  expect_false(break_process_request(x1, retryonratelimit = TRUE))
  expect_false(break_process_request(
    x1,
    retryonratelimit = TRUE,
    verbose = TRUE
  ))
  expect_false(break_process_request(
    x1,
    retryonratelimit = FALSE,
    verbose = TRUE
  ))
  ## alternative pager
  x2 <- x1
  names(attr(x2, "headers"))[4] <- "since_id"
  expect_false(break_process_request(x2, pager = "since_id"))
  expect_false(break_process_request(
    x2,
    retryonratelimit = TRUE,
    pager = "since_id"
  ))
  expect_false(break_process_request(
    x2,
    retryonratelimit = TRUE,
    verbose = TRUE,
    pager = "since_id"
  ))
  expect_false(break_process_request(
    x2,
    retryonratelimit = FALSE,
    verbose = TRUE,
    pager = "since_id"
  ))
  x3 <- x1
  attr(x3, "headers")[["max_id"]] <- NULL
  expect_true(break_process_request(x3, pager = "max_id"))
  expect_true(break_process_request(
    x3,
    retryonratelimit = TRUE,
    pager = "max_id"
  ))
  expect_true(break_process_request(
    x3,
    retryonratelimit = TRUE,
    verbose = TRUE,
    pager = "max_id"
  ))
  expect_true(break_process_request(
    x3,
    retryonratelimit = FALSE,
    verbose = TRUE,
    pager = "max_id"
  ))
  ## emulate `rate_remaining` reaching zero
  zero_x <- x1
  attr(zero_x, "headers")[["rate_remaining"]] <- "0"
  expect_equal(rate_limit_remaining(zero_x), 0)
  ## retryonratelimit = FALSE
  expect_true(break_process_request(
    zero_x,
    retryonratelimit = FALSE,
    pager = "max_id"
  ))
  expect_silent(break_process_request(
    zero_x,
    retryonratelimit = FALSE,
    pager = "max_id"
  ))
  expect_message(
    break_process_request(
      zero_x,
      retryonratelimit = FALSE,
      verbose = TRUE,
      pager = "max_id"
    ),
    "rate limit reached"
  )
  ## retryonratelimit = TRUE
  fake_current_time <- attr(zero_x, "headers")[["rate_reset"]] - 1
  expect_false(break_process_request(
    zero_x,
    retryonratelimit = TRUE,
    pager = "max_id",
    from = fake_current_time
  ))
  expect_silent(break_process_request(
    zero_x,
    retryonratelimit = TRUE,
    pager = "max_id",
    from = fake_current_time
  ))
  expect_message(
    break_process_request(
      zero_x,
      retryonratelimit = TRUE,
      verbose = TRUE,
      pager = "max_id",
      from = fake_current_time
    ),
    "1 second"
  )
  ## pager is null; retryonratelimit has no effect
  zero_x_null <- zero_x
  expect_equal(rate_limit_remaining(zero_x_null), 0)
  attr(zero_x_null, "headers")[["max_id"]] <- NULL
  expect_true(break_process_request(zero_x_null, pager = "max_id"))
  expect_true(break_process_request(
    zero_x_null,
    retryonratelimit = TRUE,
    pager = "max_id"
  ))
  expect_true(break_process_request(
    zero_x_null,
    retryonratelimit = TRUE,
    verbose = TRUE,
    pager = "max_id"
  ))
  expect_true(break_process_request(
    zero_x_null,
    retryonratelimit = FALSE,
    verbose = TRUE,
    pager = "max_id"
  ))
  expect_silent(break_process_request(
    zero_x_null,
    retryonratelimit = FALSE,
    verbose = TRUE,
    pager = "max_id"
  ))
  expect_silent(break_process_request(
    zero_x_null,
    retryonratelimit = TRUE,
    verbose = TRUE,
    pager = "max_id"
  ))
})
