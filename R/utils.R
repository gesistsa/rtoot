# print.rtoot_client <- function(x,...){
#   cat("<mastodon client> for instance:", x$instance, "\n")
#   invisible(x)
# }

#' @export
print.rtoot_bearer <- function(x,...){
  cat("<mastodon bearer token> for instance:", x$instance, "of type:",x$type,"\n")
  invisible(x)
}

#' Query Mastodon API
#'
#' This is a minimalistic interface for querying the Mastodon API. This function is for advanced users who want to query
#' the Mastodon API for endpoints that the R functions are not yet implemented.
#' Please also note that the API responses will not be parsed as tibble. Refer to the official API documentation for endpoints and parameters.
#' @param endpoint character, a Mastodon API endpoint. Currently, only endpoints using GET are supported
#' @param ... Name-value pairs giving API parameters.
#' @param params list, API parameters to be submitted
#' @inheritParams get_timeline_public
#' @return a list
#' @export
#' @references https://docs.joinmastodon.org/methods/
#' @examples
#' \dontrun{
#' rtoot(endpoint = "api/v1/notifications")
#' rtoot(endpoint = "api/v1/notifications", limit = 8)
#' ## same
#' rtoot(endpoint = "api/v1/notifications", params = list(limit = 8))
#' rtoot(endpoint = "api/v1/followed_tags")
#' ## reimplement `get_timeline_public`
#' rtoot(endpoint = "api/v1/timelines/public", instance = "emacs.ch", local = TRUE, anonymous = TRUE)
#' }
rtoot <- function(endpoint, ..., params = list(), token = NULL, instance = NULL,
                  anonymous = FALSE) {
  if (missing(endpoint)) {
    stop("Please provide an `endpoint`", call. = FALSE)
  }
  params <- c(list(...), params)
  make_get_request(token = token, path = endpoint, params = params, instance = instance, anonymous = anonymous)
}

## Endpoints under
## https://docs.joinmastodon.org/methods/statuses/
## https://docs.joinmastodon.org/methods/timelines/

make_get_request <- function(token, path, params = list(), instance = NULL, anonymous = FALSE, ...) {
  if (is.null(instance) && anonymous) {
    stop("provide either an instance or a token", call. = FALSE)
  }
  if (is.null(instance)) {
    token <- check_token_rtoot(token)
    url <- prepare_url(token$instance)
    config <- httr::add_headers(Authorization = paste('Bearer', token$bearer))
  } else {
    url <- prepare_url(instance)
    config <- list()
  }

  request_results <- httr::GET(httr::modify_url(url, path = path),
                               config,
                               query = params)

  status_code <- httr::status_code(request_results)
  if (!status_code %in% c(200)) {
    stop(paste("something went wrong. Status code:", status_code), call. = FALSE)
  }
  output <- httr::content(request_results)
  headers <- parse_header(httr::headers(request_results))
  attr(output, "headers") <- headers
  return(output)
}

# prepare urls
prepare_url <- function(instance){
  url <- httr::parse_url("")
  url$hostname <- instance
  url$scheme <- "https"
  url
}

# process the header of a get request
parse_header <- function(header){
  df <- tibble::tibble(rate_limit=header[["x-ratelimit-limit"]],
                       rate_remaining=header[["x-ratelimit-remaining"]],
                       rate_reset=format_date(header[["x-ratelimit-reset"]]))
  if("link"%in%names(header)){
    vars_to_search <- c("max_id","min_id","since_id")
    links <- regmatches(header[["link"]], gregexpr("https[^>]+", header[["link"]]))[[1]]
    query_params <- lapply(links,function(x){
      query <- httr::parse_url(x)[["query"]]
      query <- query[names(query)%in%vars_to_search]
    })
    page_param <- dplyr::bind_cols(query_params)

    return(dplyr::bind_cols(df,page_param))
  } else{
    return(df)
  }
}

#process a get request and parse output
process_request <- function(token = NULL,
                            path,
                            instance = NULL,
                            params = list(),
                            anonymous = FALSE,
                            parse = TRUE,
                            FUN = identity,
                            n = 1L,
                            page_size = 40L,
                            retryonratelimit = TRUE,
                            verbose = TRUE
) {
  # if since_id is provided we page forward, otherwise we page backwards
  if(!is.null(params[["since_id"]])) {
    pager <- "since_id"
  } else {
    pager <- "max_id"
  }
  pages <- ceiling(n/page_size)
  output <- vector("list")
  if (verbose && pages > 1) {
    pb <- txtProgressBar(min = 1, max = pages, style = 3)
    show_progress <- TRUE
  } else {
    show_progress <- FALSE
  }
  for(i in seq_len(pages)){
    api_response <- make_get_request(token = token,path = path,
                            instance = instance, params = params,
                            anonymous = anonymous)
    output <- c(output, api_response)
    attr(output, "headers") <- attr(api_response, "headers")
    if (break_process_request(api_response = api_response, retryonratelimit = retryonratelimit,
                              verbose = verbose, pager = pager)) {
      break
    }
    params[[pager]] <- attr(api_response, "headers")[[pager]]
    if (verbose && show_progress) {
      setTxtProgressBar(pb, i)
    }
  }
  if (isTRUE(parse)) {
    header <- attr(output, "headers")

    output <- FUN(output)
    attr(output, "headers") <- header
  }
  if (show_progress) {
    cat("\n")
  }
  return(output)
}

##vectorize function
v <- function(FUN) {
  v_FUN <- function(x) {
    dplyr::bind_rows(lapply(x, FUN))
  }
  return(v_FUN)
}

sayif <- function(verbose, ...) {
  if (isTRUE(verbose)) {
    message(...)
  }
}

# inspired by rtweet
wait_until <- function(until, from = Sys.time(), verbose = TRUE){
  seconds <- ceiling(as.numeric(until) - unclass(from))
  if(seconds>0){
    sayif(verbose,"Rate limit exceeded, waiting for ",seconds," seconds")
    Sys.sleep(seconds)
  }
  return(invisible())
}

rate_limit_remaining <- function(object){
  if(is.null(attr(object,"headers"))){
    stop("no header information found")
  }
  header <- attr(object,"headers")
  if(is.null(header[["rate_remaining"]])){
    warning("no rate limit information found. Setting it to the default",call. = FALSE)
    return(300)
  } else{
    return(as.numeric(header[["rate_remaining"]]))
  }
}

## A kind of drop-in replacement of utils::menu, with a plus
rtoot_menu <- function(choices = c("yes", "no"), title, default = 2L, verbose = TRUE) {
  if (!is.null(options("rtoot_cheatcode")$rtoot_cheatcode)) {
    if (options("rtoot_cheatcode")$rtoot_cheatcode == "uuddlrlrba") {
      sayif(verbose, title)
      return(options("rtoot_cheat_answer")$rtoot_cheat_answer) ### VW-Style cheating!
    }
  }
  if (isFALSE(interactive())) {
    return(default)
  }
  return(utils::menu(choices = choices, title = title))
}

## A kind of drop-in replacement of base:readline, with a plus
rtoot_ask <- function(prompt = "enter authorization code: ", pass = TRUE, check_rstudio = TRUE, default = "pass", verbose = TRUE) {
  if (!is.null(options("rtoot_cheatcode")$rtoot_cheatcode)) {
    if (options("rtoot_cheatcode")$rtoot_cheatcode == "uuddlrlrba") {
      sayif(verbose, prompt)
      return(options("rtoot_cheat_ask_answer")$rtoot_cheat_ask_answer)
    }
  }
  if (isFALSE(interactive())) {
    sayif(verbose, prompt)
    return(default)
  }
  passFun <- readline
  if (isTRUE(pass) && isTRUE(check_rstudio) && (requireNamespace("rstudioapi", quietly = TRUE))) {
    if (rstudioapi::isAvailable()) {
      passFun <- rstudioapi::askForPassword
    }
  }
  return(passFun(prompt = prompt))
}

handle_params <- function(params, max_id, since_id, min_id) {
    if (!missing(max_id)) {
        params$max_id <- max_id
    }
    if (!missing(since_id)) {
        params$since_id <- since_id
    }
    if (!missing(min_id)) {
        params$min_id <- min_id
    }
    params
}

## a predicate to determine whether to break away from the for-loop of precess_request
break_process_request <- function(api_response, retryonratelimit = FALSE, verbose = FALSE, pager = "max_id", from = Sys.time()) {
  if (is.null(attr(api_response,"headers")[[pager]])) {
    return(TRUE)
  }
  if (rate_limit_remaining(api_response) == 0 && isTRUE(retryonratelimit)) {
    wait_until(until = attr(api_response,"headers")[["rate_reset"]], from = from, verbose = verbose)
    return(FALSE)
  }
  if (rate_limit_remaining(api_response) == 0 && isFALSE(retryonratelimit)) {
    sayif(verbose,"rate limit reached and `retryonratelimit=FALSE`. returning current results.")
    return(TRUE)
  }
  return(FALSE)
}
