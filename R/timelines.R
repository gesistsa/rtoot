## Endpoints under
## https://docs.joinmastodon.org/methods/timelines/

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
#' @param bearer bearer token from [create_bearer()]
#' @return a list of statuses
#' @export
#' @examples
#' bearer <- create_bearer(instance = "social.tchncs.de")
#' get_public_timeline(bearer = bearer)
#' @references
#' https://docs.joinmastodon.org/methods/timelines/
get_public_timeline <- function(local = FALSE, remote = FALSE, only_media = FALSE, max_id, since_id, min_id, limit = 20L, bearer) {
  stopifnot(!missing(bearer))
  url <- prepare_url(bearer$instance)
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
  request_results <- httr::GET(httr::modify_url(url, path = "/api/v1/timelines/public"),
                               httr::add_headers(Authorization = paste('Bearer', bearer$bearer)),
                               query = params)
  
  status_code <- httr::status_code(request_results)
  if (!status_code %in% c(200)) {
    stop(paste("something went wrong. Status code:", status_code))
  }
  return(httr::content(request_results))
}
