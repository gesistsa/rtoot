## Endpoints under
## https://docs.joinmastodon.org/methods/statuses/
## https://docs.joinmastodon.org/methods/timelines/

make_get_request <- function(token, path, params, instance = NULL, anonymous = FALSE, ...) {
  if (is.null(instance) && anonymous) {
    stop("provide either an instance or a token")
  }

  if (is.null(instance)) {
    token <- check_token_rtoot(token)
    url <- prepare_url(token$instance)
    config <- httr::add_headers(Authorization = paste('Bearer', token$bearer))
  } else {
    url <- prepare_url(instance)
    config = list()
  }

  request_results <- httr::GET(httr::modify_url(url, path = path),
                               config,
                               query = params)

  status_code <- httr::status_code(request_results)
  if (!status_code %in% c(200)) {
    stop(paste("something went wrong. Status code:", status_code))
  }
  return(httr::content(request_results))
}

#' View specific status
#'
#' Query the instance for a specific status
#'
#' @param id character, Local ID of a status in the database
#' @param instance character, the server name of the instance where the status is located. If `NULL`, the same instance used to obtain the token is used.
#' @param anonymous some API calls do not need a token. Setting anonymous to TRUE allows to make an anonymous call if possible.
#' @param parse logical, if `TRUE`, the default, returns a tibble. Use `FALSE`  to return the "raw" list corresponding to the JSON returned from the Mastodon API.
#' @inheritParams post_toot
#' @return a status
#' @examples
#' \dontrun{
#' token <- create_token(get_client(instance = "social.tchncs.de"), type = "user")
#' get_status(id = "109298295023649405", token = token)
#' }
#' @export
get_status <- function(id, instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE) {
  # if (!anonymous) token <- check_token_rtoot(token) # TODO:check if this is needed. I do not think so
  path <- paste0("/api/v1/statuses/", id)
  output <- make_get_request(token = token, path = path, params = list(), instance = instance, anonymous = anonymous)
  if (isTRUE(parse)) {
    output <- parse_status(output)
  }
  return(output)
}

#' Get the public timeline
#'
#' Query the instance for the public timeline
#' @param local logical, Show only local statuses?
#' @param remote logical, Show only remote statuses?
#' @param only_media logical, Show only statuses with media attached?
#' @param max_id character, Return results older than this id
#' @param since_id character, Return results newer than this id
#' @param min_id character, Return results immediately newer than this id
#' @param limit integer, Maximum number of results to return
#' @inheritParams post_toot
#' @inheritParams get_status
#' @return statuses
#' @export
#' @examples
#' \dontrun{
#' token <- create_token(instance = "social.tchncs.de")
#' ## as tibble
#' get_public_timeline(token = token)
#' ## as list
#' get_public_timeline(token = token, parse = FALSE)
#' }
#' @references
#' https://docs.joinmastodon.org/methods/timelines/
get_public_timeline <- function(local = FALSE, remote = FALSE, only_media = FALSE,
                                max_id, since_id, min_id, limit = 20L, instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE) {
  params <- list(local = local, remote = remote, only_media = only_media, limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(since_id)) {
    params$since_id <- since_id
  }
  if (!missing(min_id)) {
    params$min_id <- min_id
  }
  output <- make_get_request(token = token, path = "/api/v1/timelines/public", params = params, instance = instance, anonymous = anonymous)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(lapply(output, parse_status))
  }
  return(output)
}

#' Get hashtag timeline
#'
#' Query the instance for the timeline of a specific hashtag
#' @param hashtag character, Content of a #hashtag. The hash is optional
#' @inherit get_public_timeline
#' @export
#' @examples
#' \dontrun{
#' token <- create_token(instance = "social.tchncs.de")
#' get_hashtag_timeline(hashtag = "#ichbinhanna", token = token)
#' ## anonymously
#' get_public_timeline(hashtag = "ichbinhanna", instance = "mastodon.social", anonymous = TRUE)
#' }
get_hashtag_timeline <- function(hashtag = "rstats", local = FALSE, only_media = FALSE,
                                 max_id, since_id, min_id, limit = 20L, instance = NULL,
                                 token = NULL, anonymous = FALSE, parse = TRUE) {
  params <- list(local = local, only_media = only_media, limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(since_id)) {
    params$since_id <- since_id
  }
  if (!missing(min_id)) {
    params$min_id <- min_id
  }
  path <- paste0("/api/v1/timelines/tag/", gsub("^#+", "", hashtag))
  output <- make_get_request(token = token, path = path, params = params, instance = instance, anonymous = anonymous)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(lapply(output, parse_status))
  }
  return(output)
}

