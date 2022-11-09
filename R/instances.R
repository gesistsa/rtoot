#' Get a list of fediverse servers
#'
#' @param n number of servers to show
#' @details the results are sorted by user count
#' @return data frame of fediverse instances
#' @export
get_fedi_instances  <-  function(n = 20) {
  pages <- ceiling(n/20)
  df <- tibble::tibble()
  for(i in seq_len(pages)){
    tmp <- make_get_request(token = NULL, path = "/api/instances",
                            instance = "api.index.community", params = list(sortField = "userCount", sortDirection = "desc", page = i),
                            anonymous = TRUE)
    df <- dplyr::bind_rows(df, dplyr::bind_rows(tmp$instance))
  }
  df[seq_len(n),]
}

#' Get various information about a specific instance
#' @param anonymous logical Should the API call be made anonymously? Defaults to TRUE but some instances might need authentication here
#' @param local logical. Show only local accounts?
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
#' }
#' @return instance details depending on call function
#' @export
get_instance_general <- function(instance = NULL,token = NULL, anonymous = TRUE){
  request_results <- make_get_request(token = token,path = "/api/v1/instance",
                                      instance = instance,params = list(),
                                      anonymous = anonymous)
  request_results #TODO:format?
}

#' @rdname get_instance
#' @export
get_instance_peers <- function(instance = NULL,token = NULL, anonymous = TRUE){
  request_results <- make_get_request(token = token,path = "/api/v1/instance/peers",
                                      instance = instance,params = list(),
                                      anonymous = anonymous)
  unlist(request_results)
}

#' @rdname get_instance
#' @export
get_instance_activity <- function(instance = NULL,token = NULL, anonymous = TRUE){
  request_results <- make_get_request(token = token,path = "/api/v1/instance/activity",
                                      instance = instance,params = list(),
                                      anonymous = anonymous)

  tbl <- dplyr::bind_rows(request_results)
  tbl <- dplyr::mutate(tbl,dplyr::across(dplyr::everything(),as.integer))
  tbl$week <- as.POSIXct(tbl$week,origin="1970-01-01",tz = "UTC")
  tbl
}

#' @rdname get_instance
#' @export
get_instance_emoji <- function(instance = NULL,token = NULL, anonymous = TRUE){
  request_results <- make_get_request(token = token,path = "/api/v1/custom_emojis",
                                      instance = instance,params = list(),
                                      anonymous = anonymous)
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
