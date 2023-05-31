#' Get a list of fediverse servers
#'
#' @param token token from instances.social (this is different from your Mastodon token!)
#' @param n number of servers to show
#' @param ... additional parameters for the instances.social API. See <https://instances.social/api/doc/>
#' @details This function uses the API at instances.social and needs a separate token. Results are sorted by number of users
#' @return tibble of fediverse instances
#' @export
#' @examples
#' \dontrun{
#' get_fedi_instances(n = 5)
#' }
get_fedi_instances  <-  function(token=NA,n = 20, ...) {
  if(is.na(token)){
    stop("a token from https://instances.social/api/token is needed for this function (different from Mastodon)",call. = FALSE)
  }
  config <- httr::add_headers(Authorization = paste('Bearer', token))
  params <- list(count = n,sort_by="users",sort_order="desc",...)
  request_results <- httr::GET("https://instances.social/api/1.0/instances/list",query = params,config)
  status_code <- httr::status_code(request_results)
  if (!status_code %in% c(200)) {
    stop(paste("something went wrong. Status code:", status_code))
  }
  tbl <- dplyr::bind_rows(httr::content(request_results)$instances)
  tbl[["info"]] <- NULL
  tbl <- dplyr::distinct(tbl)
  tbl[["users"]] <- as.integer(tbl[["users"]])
  tbl[["statuses"]] <- as.integer(tbl[["statuses"]])
  tbl
}
#' Get various information about a specific instance
#' @param anonymous logical, should the API call be made anonymously? Defaults to TRUE but some instances might need authentication here
#' @param local logical, show only local accounts?
#' @param offset How many accounts to skip before returning results. Default 0.
#' @param order 'active' to sort by most recently posted statuses (default) or 'new' to sort by most recently created profiles.
#' @inheritParams post_toot
#' @inheritParams get_status
#' @inheritParams get_timeline_public
#' @name get_instance
#' @details
#' \describe{
#'   \item{get_instance_general}{Returns general information about the instance}
#'   \item{get_instance_peers}{Returns the peers of an instance}
#'   \item{get_instance_activity}{Shows the weekly activity of the instance (3 months)}
#'   \item{get_instance_emoji}{Lists custom emojis available on the instance}
#'   \item{get_instance_directory}{A directory of profiles that the instance is aware of}
#'   \item{get_instance_trends}{Tags that are being used more frequently within the past week}
#'   \item{get_instance_rules}{Prints the rules of an instance}
#'   \item{get_instance_blocks}{List of domains that are blocked by an instance.}
#' }
#' @return instance details as list or tibble depending on call function
#' @examples
#' \dontrun{
#'  get_instance_general("mastodon.social")
#'  get_instance_activity("mastodon.social")
#'  get_instance_emoji("mastodon.social")
#'  get_instance_peers("mastodon.social")
#'  get_instance_directory("mastodon.social",limit = 2)
#' }
#' @export
get_instance_general <- function(instance = NULL,token = NULL, anonymous = TRUE){
  make_get_request(token = token,path = "/api/v1/instance",
                   instance = instance,
                   anonymous = anonymous) #TODO:format?
}

#' @rdname get_instance
#' @export
get_instance_peers <- function(instance = NULL,token = NULL, anonymous = TRUE){
  request_results <- make_get_request(token = token,path = "/api/v1/instance/peers",
                                      instance = instance, anonymous = anonymous)
  unlist(request_results)
}

#' @rdname get_instance
#' @export
get_instance_activity <- function(instance = NULL,token = NULL, anonymous = TRUE){
  request_results <- make_get_request(token = token,path = "/api/v1/instance/activity",
                                      instance = instance, anonymous = anonymous)
  tbl <- dplyr::bind_rows(request_results)
  tbl <- dplyr::mutate(tbl,dplyr::across(dplyr::everything(),as.integer))
  tbl$week <- as.POSIXct(tbl$week,origin="1970-01-01",tz = "UTC")
  tbl
}

#' @rdname get_instance
#' @export
get_instance_emoji <- function(instance = NULL,token = NULL, anonymous = TRUE){
  request_results <- make_get_request(token = token,path = "/api/v1/custom_emojis",
                                      instance = instance, anonymous = anonymous)
  dplyr::bind_rows(request_results)
}

#' @rdname get_instance
#' @export
get_instance_directory <- function(instance = NULL, token = NULL,
                                   offset = 0, limit = 40, order = "active",
                                   local = FALSE, anonymous = TRUE, parse = TRUE){
  params <- list(local = local, offset = offset, order = order, limit = limit)
  process_request(token = token,path = "/api/v1/directory",
                  instance = instance, params = params,
                  anonymous = anonymous, parse = parse,
                  FUN = v(parse_account))
}

#' @rdname get_instance
#' @export
get_instance_trends <- function(instance = NULL, token = NULL, limit = 10,anonymous = TRUE){
  params <- list(limit = limit)
  request_results <- make_get_request(token = token,path = "/api/v1/trends",
                                      instance = instance, params = params,
                                      anonymous = anonymous)
  tbl <- dplyr::bind_rows(request_results)
  tbl$day <- vapply(tbl$history,function(x) as.numeric(x$day),0.)
  tbl$day <- as.Date(as.POSIXct(as.numeric(tbl$day),origin="1970-01-01"))
  tbl$accounts <- vapply(tbl$history,function(x) as.integer(x$accounts),0L)
  tbl$uses <- vapply(tbl$history,function(x) as.integer(x$uses),0L)
  tbl$history <- NULL
  tbl
}

#' @rdname get_instance
#' @export
get_instance_rules <- function(instance = NULL, token = NULL, anonymous = FALSE){
  params <- list(instance = instance)
  request_results <- get_instance_general(instance = instance, token = token, anonymous = anonymous)$rules
  tbl <- dplyr::bind_rows(request_results)
  tbl
}

#' @rdname get_instance
#' @export
get_instance_blocks <- function(instance = NULL, token = NULL, anonymous = TRUE){
  request_results <- make_get_request(token = token,path = "api/v1/instance/domain_blocks",
                                      instance = instance, anonymous = anonymous)
  tbl <- dplyr::bind_rows(request_results)
  tbl
}
