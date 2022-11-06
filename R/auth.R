## login described at https://docs.joinmastodon.org/client/authorized/
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
#' @param type one of "public" or "user". See details
#' @details TBA
#' @return a mastodon bearer token
#' @export
#'
create_bearer <- function(client, type = "public"){
  type <- match.arg(type,c("public","user"))
  if(!inherits(client,"rtoot_client")){
    stop("client is not an object of type rtoot_client")
  }
  url <- prepare_url(client$instance)
  if(type=="public"){
    auth2 <- httr::POST(httr::modify_url(url = url, path = "oauth/token"),body=list(
      client_id=client$client_id ,
      client_secret=client$client_secret,
      redirect_uri='urn:ietf:wg:oauth:2.0:oob',
      grant_type='client_credentials'
    ))
    bearer <- list(bearer = httr::content(auth2)$access_token)
  } else if(type == "user"){
    httr::BROWSE(httr::modify_url(url = url, path = "oauth/authorize"),query=list(
      client_id=client$client_id ,
      redirect_uri='urn:ietf:wg:oauth:2.0:oob',
      scope='read write follow',
      response_type="code"
    ))
    auth_code <- readline(prompt = "enter authorization code: ")
    bearer <- list("bearer" = auth_code)
  }
  bearer$type <- type
  bearer$instance <- client$instance
  bearer$client_id <- client$client_id
  bearer$client_secret <- client$client_secret
  class(bearer) <- "rtoot_bearer"
  bearer
}


verify_credentials <- function(token){
  if(!inherits(token,"rtoot_bearer")){
    stop("token is not an object of type rtoot_bearer")
  }
  url <- prepare_url(token$instance)
  acc <- httr::GET(httr::modify_url(url = url, path = "api/v1/accounts/verify_credentials"),
             httr::add_headers(Authorization = paste0("Bearer ",token$bearer))
  )
}


