original_envvar <- Sys.getenv("RTOOT_DEFAULT_TOKEN")
original_option <- options("rtoot_token")$rtoot_token
options("rtoot_cheatcode" = NULL)

gen_random_token <- function() {
  paste0(sample(c(LETTERS, letters, 0:9), 43, replace = TRUE), collapse = "")
}

fake_token <- list(bearer = gen_random_token())
fake_token$type <- "user"
fake_token$instance <- "fake_token"
class(fake_token) <- "rtoot_bearer"

saved_token_path <- tempfile(fileext = ".rds")

saved_token <- list(bearer = gen_random_token())
saved_token$type <- "user"
saved_token$instance <- "saved_token"
class(saved_token) <- "rtoot_bearer"
saveRDS(saved_token, saved_token_path)

envvar_token <- list(bearer = gen_random_token())
envvar_token$type <- "user"
envvar_token$instance <- "envvar_token"
class(envvar_token) <- "rtoot_bearer"
envvar_string <- strsplit(
  convert_token_to_envvar(envvar_token, clipboard = FALSE, verbose = FALSE),
  "\""
)[[1]][2]

test_that("seven conditions", {
  skip_if(!file.exists(saved_token_path))
  ## don't test the all FALSE condition; see below
  condition <- tibble::tibble(expand.grid(
    token = c(TRUE, FALSE),
    envvar = c(TRUE, FALSE),
    rds = c(TRUE, FALSE)
  ))[1:7, ]
  expect_outcome <- list(
    fake_token,
    envvar_token,
    fake_token,
    saved_token,
    fake_token,
    envvar_token,
    fake_token
  )
  for (i in sample(seq_len(nrow(condition)))) {
    if (isTRUE(condition$token[i])) {
      token <- fake_token
    } else {
      token <- NULL
    }
    if (isTRUE(condition$envvar[i])) {
      Sys.setenv(RTOOT_DEFAULT_TOKEN = envvar_string)
    } else {
      Sys.setenv(RTOOT_DEFAULT_TOKEN = "")
    }
    if (isTRUE(condition$rds[i])) {
      options("rtoot_token" = saved_token_path)
    } else {
      options("rtoot_token" = NULL)
    }
    output <- check_token_rtoot(token = token)
    expect_equal(output, expect_outcome[[i]])
  }
  ## all false ## Well, if ~/.config/R/rtoot/ contains any token, it will return one.
  ## Sys.setenv(RTOOT_DEFAULT_TOKEN = "")
  ## options("rtoot_token" = NULL)
  ## token <- NULL
  ## print(check_token_rtoot(token))
})

test_that("cheatmode", {
  skip_on_cran()
  ## Enter cheatmode
  options("rtoot_cheatcode" = "uuddlrlrba")
  default_ans <- gen_random_token()
  options("rtoot_cheat_answer" = default_ans)
  expect_message(x <- rtoot_menu(title = "123"))
  expect_equal(x, default_ans)
})

test_that("cheatmode, invalid_token", {
  skip_on_cran()
  options("rtoot_cheatcode" = "uuddlrlrba")
  options("rtoot_cheat_answer" = 2)
  expect_error(x <- check_token_rtoot(token = iris, verbose = FALSE))
  output <- capture_message(check_token_rtoot(token = iris, verbose = TRUE))
  expect_true(grepl(
    "Your token is invalid. Do you want to authenticate now?",
    output
  ))
  options("rtoot_cheatcode" = NULL)
  options("rtoot_cheat_answer" = NULL)
})

test_that("cheatmode, file doesn't exist", {
  skip_on_cran()
  options("rtoot_cheatcode" = "uuddlrlrba")
  options("rtoot_cheat_answer" = 2)
  random_path <- tempfile(fileext = gen_random_token())
  expect_false(file.exists(random_path))
  options("rtoot_token" = random_path)
  Sys.setenv(RTOOT_DEFAULT_TOKEN = "")
  expect_error(x <- check_token_rtoot(verbose = FALSE))
  output <- capture_message(check_token_rtoot(verbose = TRUE))
  expect_true(grepl(
    "This seems to be the first time you are using rtoot. Do you want to authenticate now?",
    output
  ))
  options("rtoot_cheatcode" = NULL)
  options("rtoot_cheat_answer" = NULL)
})

test_that("cheatmode, nothing in ~/.config/R/rtoot/", {
  skip_on_cran()
  skip_if(length(list.files(tools::R_user_dir("rtoot", "config"))) != 0)
  options("rtoot_cheatcode" = "uuddlrlrba")
  options("rtoot_cheat_answer" = 2)
  options("rtoot_token" = NULL)
  Sys.setenv(RTOOT_DEFAULT_TOKEN = "")
  expect_error(x <- check_token_rtoot(verbose = FALSE))
  output <- capture_message(check_token_rtoot())
  expect_true(grepl(
    "This seems to be the first time you are using rtoot. Do you want to authenticate now?",
    output
  ))
  options("rtoot_cheatcode" = NULL)
  options("rtoot_cheat_answer" = NULL)
})

test_that("A valid token in ~/.config/R/rtoot/", {
  skip_on_cran()
  skip_if(length(list.files(tools::R_user_dir("rtoot", "config"))) != 0)
  ## skip if that's not writable
  skip_if(file.access(tools::R_user_dir("rtoot", "config"), mode = 2) != 0)
  options("rtoot_token" = NULL)
  Sys.setenv(RTOOT_DEFAULT_TOKEN = "")
  saved_token2 <- list(bearer = gen_random_token())
  saved_token2$type <- "user"
  saved_token2$instance <- "saved_token"
  class(saved_token2) <- "rtoot_bearer"
  save_auth_rtoot(saved_token2, "rtoot_test")
  expect_true(file.exists(file.path(
    tools::R_user_dir("rtoot", "config"),
    "rtoot_test.rds"
  )))
  expect_true(is.null(options("rtoot_token")$rtoot_token))
  expect_equal(saved_token2, check_token_rtoot(verbose = FALSE))
  expect_false(is.null(options("rtoot_token")$rtoot_token))
  unlink(file.path(tools::R_user_dir("rtoot", "config"), "rtoot_test.rds"))
})

## A crazy bug
## test_that("cheatmode, An invalid rds in ~/.config/R/rtoot/", {
##   skip_on_cran()
##   skip_if(length(list.files(tools::R_user_dir("rtoot", "config"))) != 0)
##   ## skip if that's not writable
##   skip_if(file.access(tools::R_user_dir("rtoot", "config"), mode = 2) != 0)
##   options("rtoot_token" = NULL)
##   Sys.setenv(RTOOT_DEFAULT_TOKEN = "")
##   saveRDS(iris, file.path(tools::R_user_dir("rtoot", "config"), "rtoot_test.rds"))
##   expect_true(file.exists(file.path(tools::R_user_dir("rtoot", "config"), "rtoot_test.rds")))
##   expect_true(is.null(options("rtoot_token")$rtoot_token))
##   options("rtoot_cheatcode" = "uuddlrlrba")
##   options("rtoot_cheat_answer" = 2)
##   expect_error(x <- check_token_rtoot(verbose = FALSE))
##   output <- capture_message(check_token_rtoot(verbose = TRUE))
##   expect_true(grepl("Your token is invalid. Do you want to authenticate now?", output))
##   options("rtoot_cheatcode" = NULL)
##   options("rtoot_cheat_answer" = NULL)
##   expect_true(is.null(options("rtoot_token")$rtoot_token)) ## shouldn't change
##   unlink(file.path(tools::R_user_dir("rtoot", "config"), "rtoot_test.rds"))
## })

## tear down

Sys.setenv(RTOOT_DEFAULT_TOKEN = original_envvar)
options("rtoot_token" = original_option)
unlink(saved_token_path)
options("rtoot_cheatcode" = NULL)
options("rtoot_cheat_answer" = NULL)
