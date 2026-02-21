#' Post status update to user's Mastodon account
#' @description Be aware that excessive automated posting is frowned upon (or even against the ToS) in many instances. Make sure to check the ToS of your instance and be mindful when using this function.
#' @param status character, toot status. Must be 500 characters or less.
#' @param media character, path to media to add to post
#' @param alt_text character, a plain-text description of the media, for accessibility purposes.
#' @param token user bearer token (read from file by default)
#' @param in_reply_to_id character, ID of the status being replied to, if status is a reply
#' @param sensitive  logical, mark status and attached media as sensitive?
#' @param spoiler_text character, text to be shown as a warning or subject before the actual content. Statuses are generally collapsed behind this field.
#' @param visibility character, Visibility of the posted status. One of public (default), unlisted, private, direct.
#' @param scheduled_at ISO 8601 Datetime at which to schedule a status. Must be at least 5 minutes in the future.
#' @param language ISO 639 language code for this status.
#' @return API response, invisibly. If the status was posted successfully, the response will contain the posted status.
#' @inheritParams auth_setup
#' @examples
#' \dontrun{
#' # post a simple status
#' post_toot("my first rtoot #rstats")
#' # post a media file with alt text
#' post_toot("look at this pic", media = "path/to/image", alt_text = "describe image")
#' }
#' @export
post_toot <- function(
  status = "my first rtoot #rstats",
  media = NULL,
  alt_text = NULL,
  token = NULL,
  in_reply_to_id = NULL,
  sensitive = FALSE,
  spoiler_text = NULL,
  visibility = "public",
  scheduled_at = NULL,
  language = NULL,
  verbose = TRUE
) {
  token <- check_token_rtoot(token)
  if (!is.character(status) || length(status) != 1) {
    cli::cli_abort(
      "`status` must be a string, it is a {typeof(status)} of length {length(status)}."
    )
  }
  if (!is.null(media)) {
    check_media(media, alt_text)
    media_id_string <- character(length(media))
    for (i in seq_along(media)) {
      media_id_string[[i]] <- upload_media_to_mastodon(
        media[[i]],
        alt_text[[i]],
        token
      )
    }
    media_id_string <- lapply(media_id_string, identity) # paste(media_id_string, collapse = ",")
    names(media_id_string) <- rep("media_ids[]", length(media_id_string))
    params <- c(
      status = status,
      media_id_string
    )
  } else {
    params <- list(status = status)
  }
  if (!is.null(in_reply_to_id)) {
    params[["in_reply_to_id"]] <- in_reply_to_id
  }
  params[["sensitive"]] <- tolower(as.logical(sensitive))
  if (!is.null(spoiler_text)) {
    params[["spoiler_text"]] <- spoiler_text
  }
  visibility <- match.arg(
    visibility,
    c("public", "unlisted", "private", "direct")
  )
  params[["visibility"]] <- visibility
  if (!is.null(scheduled_at)) {
    params[["scheduled_at"]] <- scheduled_at
  }
  if (!is.null(language)) {
    params[["language"]] <- language
  }
  r <- make_request(token$instance, "api/v1/statuses", token$bearer) |>
    httr2::req_body_form(!!!params) |>
    httr2::req_perform()
  check_status_code(
    r,
    200,
    "Failed to post toot. Status code: {httr2::resp_status(r)}"
  )
  sayif(verbose, "Your toot has been posted!")
  invisible(r)
}

upload_media_to_mastodon <- function(media, alt_text, token) {
  r <- make_request(token$instance, "api/v1/media", token$bearer) |>
    httr2::req_body_multipart(
      file = curl::form_file(media),
      description = alt_text
    ) |>
    httr2::req_perform()
  check_status_code(
    r,
    200,
    paste0(
      "Error while uploading: ",
      media,
      ". Status Code: ",
      httr2::resp_status(r)
    )
  )
  httr2::resp_body_json(r)$id
}

check_media <- function(media, alt_text) {
  if (!is.character(media) || !is.character(alt_text)) {
    cli::cli_abort(
      "Media and alt_text must be character vectors.",
      call. = FALSE
    )
  }

  if (!is.null(alt_text) && length(alt_text) != length(media)) {
    cli::cli_abort(
      "Alt text for media isn't provided for each image.",
      call. = TRUE
    )
  }

  if (any(nchar(alt_text) > 1000)) {
    cli::cli_abort(
      "Alt text cannot be longer than 1000 characters.",
      call. = TRUE
    )
  }
}

#' Perform actions on an account
#' @inheritParams post_toot
#' @param id character, user id to perform the action on
#' @param action character, one of "(un)follow","(un)block", "(un)mute", "(un)pin","note"
#' @param comment character (if action="note"), The comment to be set on that user. Provide an empty string or leave out this parameter to clear the currently set note.
#' @return no return value, called for site effects
#' @inheritParams auth_setup
#' @examples
#' \dontrun{
#' # follow a user
#' post_user("xxxxxx", action = "follow")
#' # unfollow a user
#' post_user("xxxxxx", action = "unfollow")
#' }
#' @export
post_user <- function(
  id,
  action = "follow",
  comment = "",
  token = NULL,
  verbose = TRUE
) {
  token <- check_token_rtoot(token)
  action <- match.arg(
    action,
    c(
      "follow",
      "unfollow",
      "block",
      "unblock",
      "mute",
      "unmute",
      "pin",
      "unpin",
      "note"
    )
  )
  path <- paste0("/api/v1/accounts/", id, "/", action)
  if (action == "note") {
    params <- list(comment = comment)
  } else {
    params <- list()
  }

  r <- make_request(token$instance, path, token$bearer) |>
    httr2::req_body_form(!!!params) |>
    httr2::req_perform()
  check_status_code(
    r,
    200,
    "Failed to perform action on user. Status code: {httr2::resp_status(r)}"
  )
  sayif(verbose, "successfully performed action on user")
  invisible(r)
}


#' Perform actions on a status
#' @inheritParams post_toot
#' @param id character, status id to perform the action on
#' @param action character, one of "(un)favourite","(un)reblog","(un)bookmark"
#' @return no return value, called for site effects
#' @inheritParams auth_setup
#' @examples
#' \dontrun{
#' # favourite a status
#' post_status("xxxxxx", action = "favourite")
#' # unfavourite a status
#' post_status("xxxxxx", action = "unfavourite")
#' }
#' @export
post_status <- function(
  id,
  action = "favourite",
  token = NULL,
  verbose = TRUE
) {
  token <- check_token_rtoot(token)
  action <- match.arg(
    action,
    c(
      "unfavourite",
      "favourite",
      "reblog",
      "unreblog",
      "bookmark",
      "unbookmark"
    )
  )
  path <- paste0("/api/v1/statuses/", id, "/", action)
  params <- list()

  r <- make_request(token$instance, path, token$bearer) |>
    httr2::req_body_form(!!!params) |>
    httr2::req_perform()
  check_status_code(
    r,
    200,
    "Failed to perform action on status. Status code: {httr2::resp_status(r)}"
  )
  sayif(verbose, "successfully performed action on status")
  invisible(r)
}

#' Post a thread
#'
#' Create a thread of your messages.
#' @inheritParams post_toot
#' @returns A character vector with the ids of the toots posted.
#' @export
#' @examples
#' \dontrun{
#' pt <- post_thread(visibility = "direct")
#' }
post_thread <- function(
  status = c("my first rtoot #rstats", "my first thread with rtoot"),
  # media = NULL,
  # alt_text = NULL,
  token = NULL,
  sensitive = FALSE,
  spoiler_text = NULL,
  visibility = "public",
  scheduled_at = NULL,
  language = NULL,
  verbose = TRUE
) {
  token <- check_token_rtoot(token)
  if (!is.character(status)) {
    cli::cli_abort("`status` must be a string, it is a {typeof(status)}.")
  }
  toot_id <- NULL
  ids <- vector("character", length = length(status))
  for (msg_i in seq_along(status)) {
    toot <- post_toot(
      status[msg_i],
      in_reply_to_id = toot_id,
      token = token,
      sensitive = sensitive,
      spoiler_text = spoiler_text,
      visibility = visibility,
      scheduled_at = scheduled_at,
      language = language,
      verbose = FALSE
    )
    resp <- httr2::resp_body_json(toot)
    ids[msg_i] <- resp$id
    toot_id <- ids[msg_i]
  }
  if (sum(!nzchar(ids)) == length(status)) {
    sayif(verbose, "Your thread has been posted")
  }
  invisible(ids)
}
