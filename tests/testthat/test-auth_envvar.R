original_envvar <- Sys.getenv("RTOOT_DEFAULT_TOKEN")

test_that("convert_token_to_envvar", {
  fake_token <- list(bearer = paste0(rep("a", 43), collapse = ""))
  fake_token$type <- "user"
  fake_token$instance <- paste0(rep("b", 10), collapse = "")
  class(fake_token) <- "rtoot_bearer"
  x <- convert_token_to_envvar(fake_token, clipboard = FALSE, verbose = FALSE)
  expected_output <- paste0(
    "RTOOT_DEFAULT_TOKEN=\"",
    paste0(rep("a", 43), collapse = ""),
    ";user;",
    paste0(rep("b", 10), collapse = ""),
    "\""
  )
  expect_equal(x, expected_output)
})

test_that("convert_token_to_envvar (clipboard)", {
  skip_if_not(clipr::clipr_available())
  fake_token <- list(bearer = paste0(rep("a", 43), collapse = ""))
  fake_token$type <- "user"
  fake_token$instance <- paste0(rep("b", 10), collapse = "")
  class(fake_token) <- "rtoot_bearer"
  expected_output <- paste0(
    "RTOOT_DEFAULT_TOKEN=\"",
    paste0(rep("a", 43), collapse = ""),
    ";user;",
    paste0(rep("b", 10), collapse = ""),
    "\""
  )
  expect_message(convert_token_to_envvar(
    fake_token,
    clipboard = TRUE,
    verbose = TRUE
  ))
  x <- convert_token_to_envvar(fake_token, clipboard = TRUE, verbose = FALSE)
  clipboard_content <- clipr::read_clip()
  expect_equal(clipr::read_clip(), expected_output)
  expect_equal(x, expected_output)
})

test_that("get_token_from_envvar", {
  ## NB: This is not an exported function
  skip_if(Sys.getenv("RTOOT_DEFAULT_TOKEN") == "")
  x <- get_token_from_envvar()
  expect_true("rtoot_bearer" %in% class(x))
  ## temper the envvar
  Sys.setenv(RTOOT_DEFAULT_TOKEN = "")
  expect_error(x <- get_token_from_envvar())
  expect_message(x <- get_token_from_envvar(check_stop = FALSE))
  ## should still return a dummy token
  expect_true("rtoot_bearer" %in% class(x))
  expect_equal(x$bearer, "")
  ## malformed
  Sys.setenv(RTOOT_DEFAULT_TOKEN = "elonmusk")
  expect_error(x <- get_token_from_envvar(check_stop = TRUE))
  x <- get_token_from_envvar(check_stop = FALSE)
  expect_null(x)
  expect_false("rtoot_bearer" %in% class(x))
})

Sys.setenv(RTOOT_DEFAULT_TOKEN = original_envvar)
