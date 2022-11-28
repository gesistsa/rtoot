## original_envvar <- Sys.getenv("RTOOT_DEFAULT_TOKEN")
original_option <- options("rtoot_token")$rtoot_token
options("rtoot_cheatcode" = NULL)

test_that("auth_setup, instance NULL type NULL", {
  skip_on_cran()
  options("rtoot_cheatcode" = "uuddlrlrba")
  options("rtoot_cheat_ask_answer" = "emacs.ch")
  options("rtoot_cheat_answer" = 1)
  saved_token_path <- tempfile(fileext = ".rds")
  vcr::use_cassette("auth_setup_1", {
    expect_error(capture_messages(token <- auth_setup(instance = NULL, type = NULL, clipboard = FALSE, verbose = TRUE, path = saved_token_path)), NA)
    expect_error(verify_credentials(token, verbose = FALSE), NA)
    expect_true(file.exists(saved_token_path))
  })
  unlink(saved_token_path)
})

options("rtoot_cheatcode" = NULL)
options("rtoot_cheat_answer" = NULL)
options("rtoot_cheat_ask_answer" = NULL)

test_that("respect verbose, #113", {
  ## https://github.com/schochastics/rtoot/issues/113
  saved_token_path <- tempfile(fileext = ".rds")
  vcr::use_cassette("auth_setup_verbose", {
    expect_silent(token <- auth_setup(instance = "emacs.ch", type = "public", clipboard = FALSE, verbose = FALSE, path = saved_token_path))
    expect_message(token <- auth_setup(instance = "emacs.ch", type = "public", clipboard = FALSE, verbose = TRUE, path = saved_token_path))
  })
  unlink(saved_token_path)
})
