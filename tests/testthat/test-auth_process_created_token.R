original_envvar <- Sys.getenv("RTOOT_DEFAULT_TOKEN")
Sys.setenv(RTOOT_DEFAULT_TOKEN = "abc;user;fosstodon.org")
fake_token <- get_token_from_envvar()

testing_path <- file.path(tempdir(), "rtoot_check")
testing_name <- "testing"
## we can't test the case when path is NULL because we might not be able to write to ~/

test_that("issue 72: path is FALSE", {
  expect_error(
    x <- process_created_token(
      token = fake_token,
      path = FALSE,
      clipboard = FALSE,
      verify = FALSE,
      verbose = FALSE
    ),
    NA
  )
  expect_identical(x, fake_token)
})

test_that("path is not FALSE", {
  expect_error(
    x <- process_created_token(
      token = fake_token,
      path = testing_path,
      clipboard = FALSE,
      verify = FALSE,
      verbose = FALSE
    ),
    NA
  )
  expect_identical(x, fake_token)
  expect_true(file.exists(file.path(testing_path, "rtoot_token.rds")))
  unlink(testing_path, recursive = TRUE)
})

test_that("name is not NULL", {
  expect_error(
    x <- process_created_token(
      token = fake_token,
      name = testing_name,
      path = testing_path,
      clipboard = FALSE,
      verify = FALSE,
      verbose = FALSE
    ),
    NA
  )
  expect_identical(x, fake_token)
  expect_true(file.exists(file.path(
    testing_path,
    paste0(testing_name, ".rds")
  )))
  unlink(testing_path, recursive = TRUE)
})

test_that("clipboard and verbose", {
  skip_if_not(clipr::clipr_available())
  expect_error(
    x <- process_created_token(
      token = fake_token,
      path = FALSE,
      clipboard = TRUE,
      verify = FALSE,
      verbose = FALSE
    ),
    NA
  )
  expect_identical(x, fake_token)
  expect_false(dir.exists(testing_path))
  expected_output <- paste0("RTOOT_DEFAULT_TOKEN=\"abc;user;fosstodon.org\"")
  expect_equal(clipr::read_clip(), expected_output)
  expect_message(
    x <- process_created_token(
      token = fake_token,
      path = FALSE,
      clipboard = TRUE,
      verify = FALSE,
      verbose = TRUE
    )
  )
  expect_identical(x, fake_token)
  expect_false(dir.exists(testing_path))
})

test_that("verify", {
  ## This is fake token; so the API call should return error if `verify` is TRUE
  vcr::use_cassette("process_created_token", {
    expect_error(
      x <- process_created_token(
        token = fake_token,
        path = FALSE,
        clipboard = FALSE,
        verify = TRUE,
        verbose = FALSE
      )
    )
  })
  expect_error(
    x <- process_created_token(
      token = fake_token,
      path = FALSE,
      clipboard = FALSE,
      verify = FALSE,
      verbose = TRUE
    ),
    NA
  )
})

Sys.setenv(RTOOT_DEFAULT_TOKEN = original_envvar)
