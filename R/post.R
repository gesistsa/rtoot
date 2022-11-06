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

  if(!inherits(token,"rtoot_bearer")){
    stop("token is not an object of type rtoot_bearer")
  }
  stopifnot(is.character(status), length(status) == 1)
  if(!is.null(media)){

  # TODO with upload_media_to_mastodon
  } else{
    params <- list("status" = status)
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
    params[["schedule_at"]] <- schedule_at
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

upload_media_to_mastodon <- function(){

}
