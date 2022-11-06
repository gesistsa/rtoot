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
  } else if(type == "user"){
    httr::BROWSE(httr::modify_url(url = url, path = "oauth/authorize"),query=list(
      client_id=client$client_id ,
      redirect_uri='urn:ietf:wg:oauth:2.0:oob',
      scope='read write follow',
      response_type="code"
    ))
    auth_code <- readline(prompt = "enter authorization code: ")
    auth2 <- httr::POST(httr::modify_url(url = url, path = "oauth/token"),body=list(
      client_id=client$client_id ,
      client_secret=client$client_secret,
      redirect_uri='urn:ietf:wg:oauth:2.0:oob',
      grant_type='authorization_code',
      code = auth_code,
      scope = "read write follow"
    ))
  }
  bearer <- list(bearer = httr::content(auth2)$access_token)
  bearer$type <- type
  bearer$instance <- client$instance
  class(bearer) <- "rtoot_bearer"
  bearer
}


#' verify mastodon credentials
#'
#' @param token user bearer token
#'
#' @return mastodon account
#' @export
verify_credentials <- function(token=NULL){
  if(is.null(token)){
    token <- get_auth_rtoot()
  }
  url <- prepare_url(token$instance)
  acc <- httr::GET(httr::modify_url(url = url, path = "api/v1/accounts/verify_credentials"),
             httr::add_headers(Authorization = paste0("Bearer ",token$bearer))
  )
  acc
}

#' save a bearer token to file
#'
#' @param token bearer token created with [create_bearer]
#'
#' @export
save_auth_rtoot <- function(token){
  if(!inherits(token,"rtoot_bearer")){
    stop("token is not an object of type rtoot_bearer")
  }
  dir.create(auth_path_rtoot(), showWarnings = FALSE, recursive = TRUE)
  out_file <- auth_path_rtoot("default.rds")
  saveRDS(token,out_file)
  invisible(token)
}

get_auth_rtoot <- function(){
  path <- file.path(tools::R_user_dir("rtoot", "config"), "default.rds")
  if(!file.exists(path)){
    stop("no token found in default location. Use save_auth_rtoot(token) with a token created from create_bearer()")
  }
  readRDS(path)
}

auth_path_rtoot <- function(...){
  path <- tools::R_user_dir("rtoot", "config")
  file.path(path,...)
}

is_auth_rtoot <- function(token){
  if(!inherits(token,"rtoot_bearer")){
    return(FALSE)
  } else{
    return(TRUE)
  }
}

check_token_rtoot <- function(token = NULL){
  if(!is.null(token)){
    if(!is_auth_rtoot(token)){
      stop("token is not an object of type rtoot_bearer")
    }
  } else{
    token <- get_auth_rtoot()
  }
  return(token)
}
