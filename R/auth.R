#' register a mastodon client
#'
#' @param instance server name
#'
#' @return an rtoot client object
#' @export
#'
get_client <- function(instance = "mastodon.social"){
  url <- prepare_url(instance)
  auth1 <- httr::POST(httr::modify_url(url = url, path = "/api/v1/apps"),body=list(
    client_name="rtoot package",
    redirect_uris="urn:ietf:wg:oauth:2.0:oob",
    scopes="read write follow"))
  client <- httr::content(auth1)
  client <- client[c("client_id","client_secret")]
  client$instance <- instance
  class(client) <- "rtoot_client"
  client
}

#' get a bearer token for the mastodon api
#'
#' @param client rtoot client object created with [get_client]
#'
#' @return a maatodon bearer token
#' @export
#'
create_bearer <- function(client){
  if(!inherits(client,"rtoot_client")){
    stop("client is not an object of type rtoot_client")
  }
  url <- prepare_url(client$instance)

  auth2 <- httr::POST(httr::modify_url(url = url, path = "oauth/token"),body=list(
    client_id=client$client_id ,
    client_secret=client$client_secret,
    redirect_uri='urn:ietf:wg:oauth:2.0:oob',
    grant_type='client_credentials'
  ))
  bearer <- list(bearer = httr::content(auth2)$access_token)
  bearer$instance <- client$instance
  class(bearer) <- "rtoot_bearer"
  bearer
}

prepare_url <- function(instance){
  url <- httr::parse_url("")
  url$hostname <- instance
  url$scheme <- "https"
  url
}
