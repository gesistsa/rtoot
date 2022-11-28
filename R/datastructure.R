## taken from rtweet

has_name_ <- function(x, name) isTRUE(name %in% names(x))

format_date <- function(x, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC") {
  strptime(x, format, tz = tz)
}

##https://docs.joinmastodon.org/entities/status/

## scaler: id, uri, created_at, content, visibility, sensitive (B), spoiler_text, reblogs_count, favourites_count, replies_count, url, in_reply_to_id, in_reply_to_account_id, language, text
## Only available from user token: (favourited, reblogged, muted, bookmarked, pinned)
## singluar structure: application, poll, card, account, reblog
## array: media_attachments, mentions, tags, emojis

## order the columns as in the `empty` below

parse_status <- function(status, parse_date = TRUE) {
  ## Make sure the output is like this
  empty <- empty[["status"]]
  if (is.null(status)) {
    output <- empty
  } else {
    singular_fields <- c("id", "uri", "created_at", "content", "visibility", "sensitive", "spoiler_text", "reblogs_count", "favourites_count", "replies_count", "url", "in_reply_to_id", "in_reply_to_account_id", "language", "text")
    singular_list <- lapply(status[singular_fields], function(x) ifelse(is.null(x), NA, x))
    names(singular_list) <- singular_fields
    output <- tibble::as_tibble(singular_list)
    if (parse_date) {
      output$created_at <- format_date(output$created_at)
    }
    for (field in c("application", "poll", "card")) {
      output[[field]]  <- I(list(list()))
      if (has_name_(status, field)) {
        if (!is.null(status[[field]])) {
          if (field != "poll") { ##haskish for now
            output[[field]][[1]] <- status[[field]]
          } else {
            output[[field]] <- list(parse_poll(status[[field]]))
          }
        }
      }
    }
    output[["account"]] <- list(parse_account(status[["account"]]))
    output[["reblog"]] <- I(list(list()))
    if (has_name_(status, "reblog")) {
      if (!is.null(status[["reblog"]])) {
        output[["reblog"]][[1]] <- parse_status(status[["reblog"]])
      }
    }
    for (field in c("media_attachments", "mentions", "tags", "emojis")) {
      if (has_name_(status, field) & length(status[[field]]) != 0) {
          output[[field]] <- list(dplyr::bind_rows(status[[field]]))
      } else {
        output[[field]]  <- I(list(list()))
      }
    }
    for (field in c("favourited", "reblogged", "muted", "bookmarked", "pinned")) {
      output[[field]] <- NA
      if (has_name_(status, field)) {
        if (!is.null(status[[field]])) {
          output[[field]] <- status[[field]]
        }
      }
    }
  }
  output
}

parse_account <- function(account,parse_date = TRUE){
  empty <- empty[["account"]]
  if (is.null(account)) {
    output <- empty
  } else {
    singular_fields <- c("id", "username", "acct", "display_name", "locked", "bot",
                         "discoverable", "group", "created_at", "note", "url", "avatar",
                         "avatar_static", "header", "header_static", "followers_count",
                         "following_count", "statuses_count", "last_status_at")
    singular_list <- lapply(account[singular_fields], function(x) ifelse(is.null(x), NA, x))
    names(singular_list) <- singular_fields
    output <- tibble::as_tibble(singular_list)
    if (parse_date) {
      output$created_at <- format_date(output$created_at)
      output$last_status_at <- format_date(output$last_status_at)
    }
    for (field in c("fields", "emojis")) {
      if (has_name_(account, field) & length(account[[field]]) != 0) {
        output[[field]] <- list(dplyr::bind_rows(account[[field]]))
      } else {
        output[[field]]  <- I(list(list()))
      }
    }
  }
  output
}

## https://docs.joinmastodon.org/entities/poll/
parse_poll <- function(poll, parse_date = TRUE) {
  empty <- tibble::tibble(
                     id = NA_character_, expires_at = NA_character_,
                     expired = NA, multiple = NA,
                     votes_count = NA, voters_count = NA,
                     voted = NA, own_votes = I(list(list())),
                     options = I(list(list())),
                     emojis = I(list(list())))
  if (is.null(poll)) {
    output <- empty
  } else {
    singular_fields <- c("id", "expires_at", "expired", "multiple", "votes_count", "voters_count", "voted")
    singular_list <- lapply(poll[singular_fields], function(x) ifelse(is.null(x), NA, x))
    names(singular_list) <- singular_fields
    output <- tibble::tibble(as.data.frame(singular_list))
    if (parse_date) {
      output$expires_at <- format_date(output$expires_at)
    }
    output[["own_votes"]] <- I(list(list()))
    if (has_name_(poll, "own_votes") & length(poll[["own_votes"]] != 0)) {
      output[["own_votes"]] <- list(poll[["own_votes"]])
    }
    for (field in c("options", "emojis")) {
      if (has_name_(poll, field) & length(poll[[field]]) != 0) {
        output[[field]] <- list(dplyr::bind_rows(poll[[field]]))
      } else {
        output[[field]]  <- I(list(list()))
      }
    }
  }
  output
}

parse_context <- function(output) {
  temp_output <- list()
  temp_output$ancestors <- dplyr::bind_rows(lapply(output$ancestors, parse_status))
  temp_output$descendants <- dplyr::bind_rows(lapply(output$descendants, parse_status))
  temp_output
}
