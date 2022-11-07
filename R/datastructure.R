## stole from rtweet

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
  empty <- tibble::tibble(id = NA_character_, uri = NA_character_, created_at = NA_character_, content = NA_character_, visibility = NA_character_, sensitive = NA, spoiler_text = NA_character_, reblogs_count = 0, favourites_count = 0, replies_count = 0, url = NA_character_, in_reply_to_id = NA_character_, in_reply_to_account_id = NA_character_, language = NA_character_, text = NA_character_, application = I(list(list())), poll = I(list(list())), card = I(list(list())), account = I(list(list())), reblog = I(list(list())), media_attachments = I(list(list())), mentions = I(list(list())), tags = I(list(list())), emojis = I(list(list())), favourited = NA, reblogged = NA, muted = NA, bookmarked = NA, pinned = NA)
  if (is.null(status)) {
    output <- empty
  } else {
    singular_fields <- c("id", "uri", "created_at", "content", "visibility", "sensitive", "spoiler_text", "reblogs_count", "favourites_count", "replies_count", "url", "in_reply_to_id", "in_reply_to_account_id", "language", "text")
    singular_list <- lapply(status[singular_fields], function(x) ifelse(is.null(x), NA, x))
    names(singular_list) <- singular_fields
    output <- tibble::tibble(as.data.frame(singular_list))
    if (parse_date) {
      output$created_at <- format_date(output$created_at)
    }
    ## TODO: We need to have a data structure for "account" in the future
    for (field in c("application", "poll", "card")) {
      output[[field]]  <- I(list(list()))
      if (has_name_(status, field)) {
        if (!is.null(status[[field]])) {
          output[[field]][[1]] <- status[[field]]
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
  empty <- tibble::tibble(
    id = NA_character_,
    username = NA_character_,
    acct = NA_character_,
    created_at = NA_character_,
    display_name = NA_character_,
    locked = NA,
    bot = NA,
    discoverable = NA,
    group = NA,
    note = NA_character_,
    url = NA_character_,
    avatar = NA_character_,
    avatar_static = NA_character_,
    header = NA_character_,
    header_static = NA_character_,
    follower_count = NA_integer_,
    following_count = NA_integer_,
    statuses_count = NA_integer_,
    last_status_at = NA_character_,
    emojis = I(list(list())),
    fields = I(list(list()))
  )
  if (is.null(account)) {
    output <- empty
  } else {
    singular_fields <- c("id", "username", "acct", "display_name", "locked", "bot",
                         "discoverable", "group", "created_at", "note", "url", "avatar",
                         "avatar_static", "header", "header_static", "followers_count",
                         "following_count", "statuses_count", "last_status_at")
    singular_list <- lapply(account[singular_fields], function(x) ifelse(is.null(x), NA, x))
    names(singular_list) <- singular_fields
    output <- tibble::tibble(as.data.frame(singular_list))
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
