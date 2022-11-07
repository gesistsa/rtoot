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

prepare_url <- function(instance){
  url <- httr::parse_url("")
  url$hostname <- instance
  url$scheme <- "https"
  url
}
