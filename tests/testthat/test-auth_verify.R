test_that("verify_envvar (Good case)", {
  ## The cassette was created with a valid envvar
  ## But here is a fake
  withr::local_envvar(
    RTOOT_DEFAULT_TOKEN = paste0(
      paste0(rep("a", 43), collapse = ""),
      ";user;fosstodon.org"
    )
  )
  vcr::use_cassette("envvar", {
    expect_error(x <- capture_message(verify_envvar()), NA)
  })
  expect_false("simpleError" %in% class(x))
})

test_that("verify_envvar (Good case), silent", {
  ## The cassette was created with a valid envvar
  withr::local_envvar(
    RTOOT_DEFAULT_TOKEN = paste0(
      paste0(rep("a", 43), collapse = ""),
      ";user;fosstodon.org"
    )
  )
  vcr::use_cassette("envvar_silent", {
    expect_silent(verify_envvar(verbose = FALSE))
  })
})

test_that("verify_envvar (Bad case)", {
  withr::local_envvar(RTOOT_DEFAULT_TOKEN = "")
  expect_error(verify_envvar())
})
