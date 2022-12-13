## wait_until and rate_limit_remaining

test_that("wait_until", {
  x <- capture_message(wait_until(2, 1, verbose = TRUE))
  expect_true(grepl("1 second", x))
  expect_silent(wait_until(2, 1, verbose = FALSE))
  x <- capture_message(wait_until(3, 1, verbose = TRUE))
  expect_true(grepl("2 second", x))
  added_sec <- 2
  fake_until <- as.character(as.integer(added_sec+unclass(Sys.time())))
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
  z <- data.frame(x = c(1,2,3,4))
  expect_error(rate_limit_remaining(z))
})
