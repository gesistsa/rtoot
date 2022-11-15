original_envvar <- Sys.getenv("RTOOT_DEFAULT_TOKEN")
Sys.setenv(RTOOT_DEFAULT_TOKEN = "abc;user;emacs.ch")

test_that("verify_envvar (Good case)", {
  vcr::use_cassette("envvar", {
    expect_error(capture_message(verify_envvar()), NA)
  })
})

test_that("verify_envvar (Bad case)", {
  Sys.setenv(RTOOT_DEFAULT_TOKEN = "")
  expect_error(verify_envvar())
})

Sys.setenv(RTOOT_DEFAULT_TOKEN = original_envvar)
