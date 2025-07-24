original_envvar <- Sys.getenv("RTOOT_DEFAULT_TOKEN")
# Sys.setenv(RTOOT_DEFAULT_TOKEN = "abc;user;fosstodon.org")

test_that("verify_envvar (Good case)", {
  ## The cassette was created with a valid envvar
  vcr::use_cassette("envvar", {
    expect_error(capture_message(verify_envvar()), NA)
  })
})

test_that("verify_envvar (Good case), silent", {
  ## The cassette was created with a valid envvar
  skip_on_ci()
  skip_on_cran()
  vcr::use_cassette("envvar_silent", {
    expect_silent(verify_envvar(verbose = FALSE))
  })
})

test_that("verify_envvar (Bad case)", {
  Sys.setenv(RTOOT_DEFAULT_TOKEN = "")
  expect_error(verify_envvar())
})

Sys.setenv(RTOOT_DEFAULT_TOKEN = original_envvar)
