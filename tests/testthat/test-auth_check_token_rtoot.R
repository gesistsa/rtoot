original_envvar <- Sys.getenv("RTOOT_DEFAULT_TOKEN")
original_option <- options("rtoot_token")$rtoot_token

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
envvar_string <- strsplit(convert_token_to_envvar(envvar_token, clipboard = FALSE, verbose = FALSE), "\"")[[1]][2]

test_that("seven conditions", {
  skip_if(!file.exists(saved_token_path))
  ## don't test the all FALSE condition; see below
  condition <- tibble::tibble(expand.grid(token = c(TRUE, FALSE), envvar = c(TRUE, FALSE), rds = c(TRUE, FALSE)))[1:7, ]
  expect_outcome <- list(fake_token, envvar_token, fake_token, saved_token, fake_token, envvar_token, fake_token)
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

## tear down

Sys.setenv(RTOOT_DEFAULT_TOKEN = original_envvar)
options("rtoot_token" = original_option)
unlink(saved_token_path)
