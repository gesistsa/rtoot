## Endpoints under
## https://docs.joinmastodon.org/methods/statuses/
## https://docs.joinmastodon.org/methods/timelines/

make_get_request <- function(token, path, params, instance = NULL, ...) {
  token <- check_token_rtoot(token)
  if (is.null(instance)) {
    url <- prepare_url(token$instance)
  } else {
    url <- prepare_url(instance)
  }
  request_results <- httr::GET(httr::modify_url(url, path = path),
                               httr::add_headers(Authorization = paste('Bearer', token$bearer)),
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
#' @inheritParams post_toot
#' @return a status
#' token <- create_bearer(get_client(instance = "social.tchncs.de"), type = "user")
#' get_status(id = "109298295023649405", token = token)
#' @export
get_status <- function(id, instance = NULL, token = NULL) {
  path <- paste0("/api/v1/statuses/", id)
  make_get_request(token = token, path = path, params = list(), instance = instance)
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
#' @return a list of statuses
#' @export
#' @examples
#' bearer <- create_bearer(instance = "social.tchncs.de")
#' get_public_timeline(bearer = bearer)
#' @references
#' https://docs.joinmastodon.org/methods/timelines/
get_public_timeline <- function(local = FALSE, remote = FALSE, only_media = FALSE,
                                max_id, since_id, min_id, limit = 20L, instance = NULL, token = NULL) {
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
  make_get_request(token = token, path = "/api/v1/timelines/public", params = params, instance = instance)
}
