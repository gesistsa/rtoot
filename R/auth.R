
#' get a bearer token for the mastodon api
#'
#' @param instance server name
#'
#' @return bearer token
#' @export
#'
create_bearer <- function(instance = "mastodon.social"){
  url <- httr::parse_url("")
  url$hostname <- instance
  url$scheme <- "https"
  auth1 <- httr::POST(httr::modify_url(url = url, path = "/api/v1/apps"),body=list(
    client_name="rtoot package",
    redirect_uris="urn:ietf:wg:oauth:2.0:oob",
    scopes="read write follow"))

  auth2 <- httr::POST(httr::modify_url(url = url, path = "oauth/token"),body=list(
    client_id=httr::content(auth1)$client_id ,
    client_secret=httr::content(auth1)$client_secret,
    redirect_uri='urn:ietf:wg:oauth:2.0:oob',
    grant_type='client_credentials'
  ))
  httr::content(auth2)$access_token
}
