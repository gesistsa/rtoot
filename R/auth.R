
#' get a token for the mastodon api
#'
#' @param instance server name
#'
#' @return bearer token
#' @export
#'
get_token <- function(instance = "mastodon.social"){
  base_url <- paste0("https://",instance)
  dest <- "/api/v1/apps"
  auth1 <- httr::POST(paste0(base_url,dest),body=list(
    client_name="rtoot package",
    redirect_uris="urn:ietf:wg:oauth:2.0:oob",
    scopes="read write follow"))

  auth2 <- httr::POST(paste0(base_url,"oauth/token"),body=list(
    client_id=httr::content(auth1)$client_id ,
    client_secret=httr::content(auth1)$client_secret,
    redirect_uri='urn:ietf:wg:oauth:2.0:oob',
    grant_type='client_credentials'
  ))
  httr::content(auth2)$access_token
}
