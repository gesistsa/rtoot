fake_token <- rtoot:::get_token_from_envvar(
  "RTOOT_DEFAULT_TOKEN",
  check_stop = FALSE
)
fake_token$type <- "user"
fake_token$instance <- "emacs.ch"

test_that("rtoot examples", {
  vcr::use_cassette("rtoot_examples", {
    x1 <- rtoot(
      endpoint = "api/v1/notifications",
      token = fake_token,
      limit = 2
    )
    x2 <- rtoot(
      endpoint = "api/v1/notifications",
      token = fake_token,
      params = list(limit = 3)
    )
    x3 <- rtoot(
      endpoint = "api/v1/timelines/public",
      instance = "emacs.ch",
      local = TRUE,
      anonymous = TRUE
    )
  })
  expect_error(rtoot(
    endpoint = "api/v1/timelines/public",
    local = TRUE,
    anonymous = TRUE
  ))
  expect_equal(length(x1), 2)
  expect_equal(length(x2), 3)
})
