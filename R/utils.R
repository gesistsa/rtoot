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

# prepare urls
prepare_url <- function(instance){
  url <- httr::parse_url("")
  url$hostname <- instance
  url$scheme <- "https"
  url
}

# process the header of a get request
parse_header <- function(header){
  # rate limit fields should always be present but the link field is not always there
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
    if(length(output)<1){
      output <- tibble::tibble()
    } else if(length(output[[1]])==1){ #TODO:fragile?
      output <- FUN(output)
    } else{
      output <- dplyr::bind_rows(lapply(output, FUN))
    }
    attr(output,"headers") <- header
  }
  return(output)
}
