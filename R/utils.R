#' @export
print.rtoot_client <- function(x,...){
  cat("<mastodon client> for instance:", x$instance, "\n")
  invisible(x)
}

#' @export
print.rtoot_bearer <- function(x,...){
  cat("<mastodon bearer token> for instance:", x$instance, "of type:",x$type,"\n")
  invisible(x)
}


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
                params,
                anonymous = FALSE,
                parse = TRUE,
                FUN = identity
){
  output <- make_get_request(token = token,path = path,
                             instance = instance, params = params,
                             anonymous = anonymous)
  if (isTRUE(parse)) {
    header <- attr(output,"headers")

    output <- FUN(output)
    attr(output,"headers") <- header
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
