#' Authenticate with a Mastodon instance
#'
#' @param instance a public instance of Mastodon (e.g., mastodon.social).
#' @param type Either "public" to create a public authentication or "user" to
#'   create authentication for your user (e.g., if you want to post from R or
#'   query your followers).
#' @param name give the token a name, in case you want to store more than one.
#'
#' @return A bearer token
#' @examples
#' auth_setup("mastodon.social", "public")
#' @export
auth_setup <- function(instance = NULL, type = NULL, name = NULL) {
  while (is.null(instance) || instance == "") {
    instance <- readline(prompt = "On which instance do you want to authenticate (e.g., \"mastodon.social\")?")
  }
  client <- get_client(instance = instance)
  if (!isTRUE(type %in% c("public", "user"))) {
    type <- c("public", "user")[menu(c("public", "user"), title = "What type of token do you want?")]
  }
  token <- create_token(client, type = type)
  verify_credentials(token)
  token_path <- save_auth_rtoot(token, name)
  options("rtoot_token" = token_path)
  check_token_rtoot(token)
}

## login described at https://docs.joinmastodon.org/client/authorized/
#' register a mastodon client
#'
#' @param instance server name
#'
#' @return an rtoot client object
#' @references https://docs.joinmastodon.org/client/token/#creating-our-application
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
#' @references https://docs.joinmastodon.org/client/authorized/
#' @export
#'
create_token <- function(client, type = "public"){
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
    if (require("rstudioapi", quietly = TRUE)) {
      auth_code <- rstudioapi::askForPassword(prompt = "enter authorization code: ")
    } else {
      auth_code <- readline(prompt = "enter authorization code: ")
    }
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
verify_credentials <- function(token) {
  if(!is_auth_rtoot(token)){
    stop("token is not an object of type rtoot_bearer")
  }
  url <- prepare_url(token$instance)
  acc <- httr::GET(
    httr::modify_url(url = url, path = "api/v1/accounts/verify_credentials"),
    httr::add_headers(Authorization = paste0("Bearer ",token$bearer))
  )
  success <- isTRUE(acc[["status_code"]] == 200L)
  if (success) {
    message("Token of type \"", token$type, "\" for instance ", token$instance, " is valid")
  } else {
    stop("Token not valid. Use auth_setup() to create a token")
  }
}

#' save a bearer token to file
#'
#' @param token bearer token created with [create_token]
#' @param name A file name (if you want to store more than one token).
#' @param path A path where the token is stored.
#'
#' @export
save_auth_rtoot <- function(token, name = NULL, path = NULL){
  if(!is_auth_rtoot(token)){
    stop("token is not an object of type rtoot_bearer")
  }
  if (is.null(path)) {
    path <- tools::R_user_dir("rtoot", "config")
  }
  if (is.null(name)) {
    name <- "rtoot_token"
  }
  dir.create(path, showWarnings = FALSE, recursive = TRUE)
  out_file <- file.path(path, paste0(name, ".rds"))
  saveRDS(token, out_file)
  invisible(out_file)
}

get_auth_rtoot <- function(){

  path <- file.path(tools::R_user_dir("rtoot", "config"), "default.rds")
  if(!file.exists(path)){
    stop("no token found in default location. Use save_auth_rtoot(token) with a token created from create_token()")
  }
  readRDS(path)
}

is_auth_rtoot <- function(token) inherits(token, "rtoot_bearer")

#' check if a token is available and return one if not
check_token_rtoot <- function(token = NULL) {

  selection <- NULL

  if(is.null(token)){

    token_path <- options("rtoot_token")$rtoot_token

    if (length(token_path) == 0) {
      token_path <- head(list.files(tools::R_user_dir("rtoot", "config"),
                                    full.names = TRUE,
                                    pattern = ".rds",
                                    ignore.case = TRUE), 1L)
      options("rtoot_token" = token_path)
    }

    if (isTRUE(file.exists(token_path))) {
      token <- readRDS(token_path)
    } else {
      if (interactive()) {
        selection <- menu(
          c("yes", "no"),
          title = "This seems to be the first time you are using rtoot. Do you want to authenticate now?"
        )
      } else {
        selection <- 2L
      }
    }

    if (isTRUE(selection == 1L)) {
      token <- auth_setup()
    } else if (isTRUE(selection == 2L)) {
      stop("No token found. Please run auth_setup() to authenticate.")
    }
  } else if (!is_auth_rtoot(token)) {
    if (interactive()) {
      selection <- menu(
        c("yes", "no"),
        title = "Your token is invalid. Do you want to authenticate now?"
      )
    } else {
      selection <- 2L
    }
  }

  invisible(token)
}
