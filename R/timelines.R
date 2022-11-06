## Endpoints under
## https://docs.joinmastodon.org/methods/timelines/

make_get_request <- function(token, path, params, ...) {
  url <- prepare_url(token$instance)
  request_results <- httr::GET(httr::modify_url(url, path = path),
                               httr::add_headers(Authorization = paste('Bearer', token$bearer)),
                               query = params)
  
  status_code <- httr::status_code(request_results)
  if (!status_code %in% c(200)) {
    stop(paste("something went wrong. Status code:", status_code))
  }
  return(httr::content(request_results))
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
#' @return a list of statuses
#' @export
#' @examples
#' bearer <- create_bearer(instance = "social.tchncs.de")
#' get_public_timeline(bearer = bearer)
#' @references
#' https://docs.joinmastodon.org/methods/timelines/
get_public_timeline <- function(local = FALSE, remote = FALSE, only_media = FALSE, max_id, since_id, min_id, limit = 20L, token = NULL) {
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
  make_get_request(token = token, path = "/api/v1/timelines/public", params = params)
}

## A helper function to flatten a status
flatten_status <- function(status) {
  for (i in seq_along(status)) {
    if (length(status[[i]]) > 1) {
      class(status[[i]]) <- c("rtoot_status_field", names(status)[i], class(status[[i]]))
    }
  }
  return(status)
}
