#' Post status update to user's Mastodon account
#'
#' @param status Character, toot status. Must be 500 characters or less.
#' @param media add media to post (not working yet)
#' @param alt_text A plain-text description of the media, for accessibility purposes.
#' @param token user bearer token
#' @param in_reply_to_id ID of the status being replied to, if status is a reply
#' @param sensitive  logical. Mark status and attached media as sensitive?
#' @param spoiler_text Text to be shown as a warning or subject before the actual content. Statuses are generally collapsed behind this field.
#' @param visibility Visibility of the posted status. One of public (default), unlisted, private, direct.
#' @param scheduled_at ISO 8601 Datetime at which to schedule a status. Must be at least 5 minutes in the future.
#' @param language ISO 639 language code for this status.
#' @return nothing
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
    language = NULL){

  token <- check_token_rtoot(token)

  stopifnot(is.character(status), length(status) == 1)
  if(!is.null(media)){
    check_media(media,alt_text)
    media_id_string <- character(length(media))
    for(i in seq_along(media)){
      media_id_string[[i]] <- upload_media_to_mastodon(media[[i]],alt_text[[i]],token)
    }
    media_id_string <- lapply(media_id_string,identity) #paste(media_id_string, collapse = ",")
    names(media_id_string) <- rep("media_ids[]",length(media_id_string))
    params <- c(
      status = status,
      media_id_string
    )
  } else{
    params <- list(status = status)
  }
  if(!is.null(in_reply_to_id)){
    params[["in_reply_to_id"]] <- in_reply_to_id
  }
  params[["sensitive"]] <- tolower(as.logical(sensitive))
  if(!is.null(spoiler_text)){
    params[["spoiler_text"]] <- spoiler_text
  }
  visibility <- match.arg(visibility,c("public", "unlisted", "private", "direct"))
  params[["visibility"]] <- visibility
  if(!is.null(scheduled_at)){
    params[["scheduled_at"]] <- scheduled_at
  }
  if(!is.null(language)){
    params[["language"]] <- language
  }
  url <- prepare_url(token$instance)
  r <- httr::POST(httr::modify_url(url = url, path = "api/v1/statuses"),
                  body=params,
                  httr::add_headers(Authorization = paste0("Bearer ",token$bearer)))
  if(httr::status_code(r)==200L){
    message("Your toot has been posted!")
  }
  invisible(r)
}

upload_media_to_mastodon <- function(media,alt_text,token){
  url <- prepare_url(token$instance)
  params <- list(file=httr::upload_file(media),description = alt_text)
  r <- httr::POST(httr::modify_url(url = url, path = "api/v1/media"),
                  body=params,
                  httr::add_headers(Authorization = paste0("Bearer ",token$bearer)))
  httr::content(r)$id
}

check_media <- function(media, alt_text) {
  if (!is.character(media) | !is.character(alt_text)) {
    stop("Media and alt_text must be character vectors.", call. = FALSE)
  }
  # media_type <- tools::file_ext(media)
  # if (length(media) > 4) {
  #   stop("At most 4 images per plot can be uploaded.", call. = FALSE)
  # }
  #
  # if (media_type %in% c("gif", "mp4") && length(media) > 1) {
  #   stop("Cannot upload more than one gif or video per tweet.", call. = TRUE)
  # }

  if (!is.null(alt_text) && length(alt_text) != length(media)) {
    stop("Alt text for media isn't provided for each image.", call. = TRUE)
  }
  # if (!any(media_type %in% c("jpg", "jpeg", "png", "gif", "mp4"))) {
  #   stop("Media type format not recognized.", call. = TRUE)
  # }

  if (any(nchar(alt_text) > 1000)) {
    stop("Alt text cannot be longer than 1000 characters.", call. = TRUE)
  }
}

#' Perform actions on an account
#' @inheritParams post_toot
#' @param action character, one of "(un)follow","(un)block", "(un)mute", "(un)pin","note"
#' @param comment character (if action="note"), The comment to be set on that user. Provide an empty string or leave out this parameter to clear the currently set note.
#' @return nothing
#' @export
post_user <- function(id,action = "follow",comment = "",token = NULL){
  token <- check_token_rtoot(token)
  action <- match.arg(action,c("follow","unfollow","block","unblock",
                               "mute","unmute","pin","unpin","note"))
  path <- paste0("/api/v1/accounts/",id,"/",action)
  if(action=="note"){
    params <- list(comment = comment)
  } else{
    params <- list()
  }

  url <- prepare_url(token$instance)
  r <- httr::POST(httr::modify_url(url = url, path = "api/v1/statuses"),
                  body=params,
                  httr::add_headers(Authorization = paste0("Bearer ",token$bearer)))
  if(httr::status_code(r)==200L){
    message("successfully performed action on user")
  }
  invisible(r)
}
