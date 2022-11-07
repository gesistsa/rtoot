#' Get a list of fediverse servers
#'
#' @param n number of servers to show
#' @details the results are sorted by user count
#' @return data frame of fediverse instances
#' @export
get_fedi_instances  <-  function(n = 20) {
  pages <- ceiling(n/20)
  df <- data.frame()
  for(i in seq_along(pages)){
    tmp <- jsonlite::fromJSON("https://api.index.community/api/instances?sortField=userCount&sortDirection=desc&page=",i)$instances
    df <- rbind(df,as.data.frame(do.call(rbind, lapply(tmp, rbind))))
  }
  df[1:n,]
}

#' Get various information about a specific instance
#'
#' @inheritParams post_toot
#' @inheritParams get_status
#' @name get_instance
#' @details
#' \describe{
#'   \item{get_instance_general}{Returns general information about the instance}
#'   \item{get_instance_peers}{Returns the peers of an instance}
#'   \item{get_instance_activity}{Shows the weekly activity of the instance (3 months)}
#'   \item{get_instance_emoji}{Lists custom emojis available on the instance}
#' }
#' @return list of instance details
#' @export
get_instance_general <- function(instance = NULL,token = NULL){
  if(is.null(instance)){
    token <- check_token_rtoot(token)
    instance <- token$instance
  }
  url <- prepare_url(instance)
  request_results <- httr::GET(httr::modify_url(url = url, path = "/api/v1/instance"))
  status_code <- httr::status_code(request_results)
  if (!status_code %in% c(200)) {
    stop(paste("something went wrong. Status code:", status_code))
  }
  httr::content(request_results)
}

#' @rdname get_instance
#' @export
get_instance_peers <- function(instance = NULL,token = NULL){
  if(is.null(instance)){
    token <- check_token_rtoot(token)
    instance <- token$instance
  }
  url <- prepare_url(instance)
  request_results <- httr::GET(httr::modify_url(url = url, path = "/api/v1/instance/peers"))
  status_code <- httr::status_code(request_results)
  if (!status_code %in% c(200)) {
    stop(paste("something went wrong. Status code:", status_code))
  }
  unlist(httr::content(request_results))
}

#' @rdname get_instance
#' @export
get_instance_activity <- function(instance = NULL,token = NULL){
  if(is.null(instance)){
    token <- check_token_rtoot(token)
    instance <- token$instance
  }
  url <- prepare_url(instance)
  request_results <- httr::GET(httr::modify_url(url = url, path = "/api/v1/instance/activity"))
  status_code <- httr::status_code(request_results)
  if (!status_code %in% c(200)) {
    stop(paste("something went wrong. Status code:", status_code))
  }
  tbl <- dplyr::bind_rows(httr::content(request_results))
  dplyr::mutate(tbl,dplyr::across(dplyr::everything(),as.numeric))
}

#' @rdname get_instance
#' @export
get_instance_emoji <- function(instance = NULL,token = NULL){
  if(is.null(instance)){
    token <- check_token_rtoot(token)
    instance <- token$instance
  }
  url <- prepare_url(instance)
  request_results <- httr::GET(httr::modify_url(url = url, path = "/api/v1/custom_emojis"))
  status_code <- httr::status_code(request_results)
  if (!status_code %in% c(200)) {
    stop(paste("something went wrong. Status code:", status_code))
  }
  dplyr::bind_rows(httr::content(request_results))
}
