fake_token <- rtoot:::get_token_from_envvar("RTOOT_DEFAULT_TOKEN", check_stop = FALSE)
fake_token$type <- "user"
fake_token$instance <- "social.tchncs.de"

test_that("post_toot, defensive", {
  expect_error(post_toot(status = NA, token = fake_token))
  expect_error(post_toot(status = c("I", "have", "a", "lot", "to", "say"), token = fake_token))
  expect_error(post_toot(visibility = "Let Elon read this", token = fake_token))
  ## no alt text, but with media
  expect_error(post_toot("testing in progress, please ignore", media = "../testdata/logo.png", token = fake_token))
  ## super long alttext
  expect_error(post_toot("testing in progress, please ignore", media = "../testdata/logo.png",
                         alt_text = paste(rep("a", 3000), collapse = ""), token = fake_token))
})

test_that("post_toot, real", {
  vcr::use_cassette("post_toot_default", {
    expect_error(x <- post_toot(status = "testing in progress, please ignore", token = fake_token), NA)
  })
  vcr::use_cassette("post_toot_media", {
    expect_error(x <- post_toot(status = "testing in progress, please ignore", media = "../testdata/logo.png", alt_text = "rtoot logo",
                                token = fake_token), NA)
  })
  vcr::use_cassette("post_toot_spoiler_text", {
    expect_error(x <- post_toot(status = "testing in progress, please ignore", media = "../testdata/logo.png", alt_text = "rtoot logo",
                                spoiler_text = "rtoot is the best", token = fake_token), NA)
  })
  vcr::use_cassette("post_toot_sensitive", {
    expect_error(x <- post_toot(status = "testing in progress, please ignore", media = "../testdata/logo.png", alt_text = "rtoot logo",
                                spoiler_text = "rtoot is the best", sensitive = TRUE, token = fake_token), NA)
  })
  vcr::use_cassette("post_toot_visibility", {
    expect_error(x <- post_toot(status = "testing in progress, please ignore", media = "../testdata/logo.png", alt_text = "rtoot logo",
                                spoiler_text = "rtoot is the best", visibility = "unlisted", token = fake_token), NA)
  })
  vcr::use_cassette("post_toot_language", {
    expect_error(x <- post_toot(status = "jetzt testen", media = "../testdata/logo.png", alt_text = "rtoot logo",
                                language = "de", visibility = "unlisted", token = fake_token), NA)
  })
})

test_that("post_user", {
  ## defensive
  expect_error(post_user("5358", action = "promotehimtoprofessor", token = fake_token))
  vcr::use_cassette("post_user_pin", {
    ## Thanks Tim, you are the best!
    expect_error(post_user("5358", action = "pin", token = fake_token), NA)
  })
})
