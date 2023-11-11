#' Authenticate with a Mastodon instance
#'
#' @param instance a public instance of Mastodon (e.g., mastodon.social).
#' @param type Either "public" to create a public authentication or "user" to
#'   create authentication for your user (e.g., if you want to post from R or
#'   query your followers).
#' @param name give the token a name, in case you want to store more than one.
#' @param path path to store the token in. The default is to store tokens in the
#'   path returned by `tools::R_user_dir("rtoot", "config")`.
#' @param clipboard logical, whether to export the token to the clipboard
#' @param verbose logical whether to display messages
#' @param browser if `TRUE` (default) a browser window will be opened to authenticate, else the URL will be provided so you can copy/paste this into the browser yourself
#' @details If either `name` or `path` are set to `FALSE`, the token is only
#'   returned and not saved. If you would like to save your token as an environment variable,
#'   please set `clipboard` to `TRUE`. Your token will be copied to clipboard in the environment variable
#'   format. Please paste it into your environment file, e.g. ".Renviron", and restart
#'   your R session.
#' @return A bearer token
#' @seealso [verify_credentials()], [convert_token_to_envvar()]
#' @examples
#' \dontrun{
#' auth_setup("mastodon.social", "public")
#' }
#' @export
auth_setup <- function(instance = NULL, type = NULL, name = NULL, path = NULL, clipboard = FALSE, verbose = TRUE, browser = TRUE) {
    while (is.null(instance) || instance == "") {
        instance <- rtoot_ask(prompt = "On which instance do you want to authenticate (e.g., \"mastodon.social\")? ", pass = FALSE)
    }
    client <- get_client(instance = instance)
    if (!isTRUE(type %in% c("public", "user"))) {
        type <- c("public", "user")[rtoot_menu(choices = c("public", "user"), title = "What type of token do you want?", verbose = TRUE)]
    }
    token <- process_created_token(create_token(client, type = type, browser = browser), name = name, path = path, clipboard = clipboard, verify = TRUE, verbose = verbose)
    return(token) ## explicit
}

process_created_token <- function(token, name = NULL, path = NULL, clipboard = FALSE, verify = TRUE, verbose = TRUE) {
    if (!isFALSE(name) && !isFALSE(path)) {
        token_path <- save_auth_rtoot(token, name, path)
        options("rtoot_token" = token_path)
    }
    if (isTRUE(verify)) {
        verify_credentials(token, verbose = verbose) # this should be further up before saving, but seems to often fail
    }
    if (isTRUE(clipboard)) {
        convert_token_to_envvar(token = token, clipboard = TRUE, verbose = verbose)
    }
    check_token_rtoot(token, verbose = verbose)
}

## login described at https://docs.joinmastodon.org/client/authorized/
#' register a mastodon client
#'
#' @param instance server name
#'
#' @return an rtoot client object
#' @references https://docs.joinmastodon.org/client/token/#creating-our-application
get_client <- function(instance = "mastodon.social") {
    url <- prepare_url(instance)
    auth1 <- httr::POST(httr::modify_url(url = url, path = "/api/v1/apps"), body = list(
        client_name = "rtoot package",
        redirect_uris = "urn:ietf:wg:oauth:2.0:oob",
        scopes = "read write follow"
    ))
    client <- httr::content(auth1)
    client <- client[c("client_id", "client_secret")]
    client$instance <- instance
    class(client) <- "rtoot_client"
    client
}

#' get a bearer token for the mastodon api
#'
#' @param client rtoot client object created with [get_client]
#' @param type one of "public" or "user". See details
#' @param browser if `TRUE` (default) a browser window will be opened to authenticate, else the URL will be provided so you can copy/paste this into the browser yourself
#' @details TBA
#' @return a mastodon bearer token
#' @references https://docs.joinmastodon.org/client/authorized/
create_token <- function(client, type = "public", browser = TRUE) {
    type <- match.arg(type, c("public", "user"))
    if (!inherits(client, "rtoot_client")) {
        stop("client is not an object of type rtoot_client")
    }
    url <- prepare_url(client$instance)
    if (type == "public") {
        auth2 <- httr::POST(httr::modify_url(url = url, path = "oauth/token"), body = list(
            client_id = client$client_id,
            client_secret = client$client_secret,
            redirect_uri = "urn:ietf:wg:oauth:2.0:oob",
            grant_type = "client_credentials"
        ))
    } else if (type == "user") {
        url <- httr::modify_url(url = url, path = "oauth/authorize")
        query <- list(
            client_id = client$client_id,
            redirect_uri = "urn:ietf:wg:oauth:2.0:oob",
            scope = "read write follow",
            response_type = "code"
        )
        if (browser) {
            httr::BROWSE(url, query = query)
        } else {
            message(paste("Navigate to", httr::modify_url(url, query = query), "to obtain an authorization code"))
        }
        auth_code <- rtoot_ask(prompt = "enter authorization code: ", pass = TRUE, check_rstudio = TRUE, default = "")
        auth2 <- httr::POST(httr::modify_url(url = url, path = "oauth/token"), body = list(
            client_id = client$client_id,
            client_secret = client$client_secret,
            redirect_uri = "urn:ietf:wg:oauth:2.0:oob",
            grant_type = "authorization_code",
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

#' Verify mastodon credentials
#'
#' @param token bearer token, either public or user level
#' @return Raise an error if the token is not valid. Return the response from the verification API invisibly otherwise.
#' @details If you have created your token as an environment variable, use `verify_envvar` to verify your token.
#' @inheritParams auth_setup
#' @examples
#' \dontrun{
#' # read a token from a file
#' verify_credentials(token)
#' }
#' @export
verify_credentials <- function(token, verbose = TRUE) {
    if (!is_auth_rtoot(token)) {
        stop("token is not an object of type rtoot_bearer")
    }
    type <- token$type
    url <- prepare_url(token$instance)
    if (type == "user") {
        acc <- httr::GET(
            httr::modify_url(url = url, path = "api/v1/accounts/verify_credentials"),
            httr::add_headers(Authorization = paste0("Bearer ", token$bearer))
        )
    } else if (type == "public") {
        acc <- httr::GET(
            httr::modify_url(url = url, path = "api/v1/apps/verify_credentials"),
            httr::add_headers(Authorization = paste0("Bearer ", token$bearer))
        )
    } else {
        stop("unknown token type")
    }
    success <- isTRUE(acc[["status_code"]] == 200L)
    if (success) {
        sayif(verbose, "Token of type \"", token$type, "\" for instance ", token$instance, " is valid")
    } else {
        stop("Token not valid. Use auth_setup() to create a token")
    }
    invisible(acc)
}

#' @export
#' @rdname verify_credentials
verify_envvar <- function(verbose = TRUE) {
    token <- get_token_from_envvar()
    verify_credentials(token, verbose = verbose)
}

#' save a bearer token to file
#'
#' @param token bearer token created with [create_token]
#' @param name A file name (if you want to store more than one token).
#' @param path A path where the token is stored.
save_auth_rtoot <- function(token, name = NULL, path = NULL) {
    if (!is_auth_rtoot(token)) {
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

is_auth_rtoot <- function(token) inherits(token, "rtoot_bearer")

#' Convert token to environment variable
#' @inheritParams verify_credentials
#' @inheritParams auth_setup
#' @return Token (in environment variable format), invisibily
#' @examples
#' \dontrun{
#' x <- auth_setup("mastodon.social", "public")
#' envvar <- convert_token_to_envvar(x)
#' envvar
#' }
#' @export
convert_token_to_envvar <- function(token, clipboard = TRUE, verbose = TRUE) {
    envvar_string <- paste0("RTOOT_DEFAULT_TOKEN=\"", token$bearer, ";", token$type, ";", token$instance, "\"")
    if (isTRUE(clipboard)) {
        if (clipr::clipr_available()) {
            clipr::write_clip(envvar_string)
            sayif(verbose, "Token (in environment variable format) has been copied to clipboard.")
        }
    } else {
        sayif(verbose, "Clipboard is not available.")
    }
    return(invisible(envvar_string))
}

get_token_from_envvar <- function(envvar = "RTOOT_DEFAULT_TOKEN", check_stop = TRUE) {
    dummy <- list(bearer = "")
    dummy$type <- ""
    dummy$instance <- ""
    class(dummy) <- "rtoot_bearer"
    if (Sys.getenv(envvar) == "") {
        if (check_stop) {
            stop("envvar not found.")
        } else {
            ## warn the testers
            message("You should do software testing with the `RTOOT_DEFAULT_TOKEN` envvar!\nRead: https://github.com/schochastics/rtoot/wiki/vcr")
            return(dummy)
        }
    }
    res <- strsplit(x = Sys.getenv(envvar), split = ";")[[1]]
    if (length(res) != 3) {
        if (check_stop) {
            stop("Your envvar is malformed")
        } else {
            return(NULL)
        }
    }
    bearer <- list(bearer = res[1])
    bearer$type <- res[2]
    bearer$instance <- res[3]
    class(bearer) <- "rtoot_bearer"
    bearer
}

# check if a token is available and return one if not
## it checks the envvar RTOOT_DEFAULT_TOKEN first; then RDS;
check_token_rtoot <- function(token = NULL, verbose = TRUE) {
    selection <- NULL
    if (is.null(token)) {
        if (Sys.getenv("RTOOT_DEFAULT_TOKEN") != "") {
            token <- get_token_from_envvar("RTOOT_DEFAULT_TOKEN", check_stop = FALSE)
            if (!is.null(token)) {
                return(token)
            }
            ## the envvar is malformed, go to the legacy RDS method.
        }
        token_path <- options("rtoot_token")$rtoot_token
        if (length(token_path) == 0) {
            token_path <- utils::head(list.files(tools::R_user_dir("rtoot", "config"),
                full.names = TRUE,
                pattern = ".rds",
                ignore.case = TRUE
            ), 1L)
            options("rtoot_token" = token_path)
        }

        if (isTRUE(file.exists(token_path))) {
            token <- readRDS(token_path)
        } else {
            selection <- rtoot_menu(
                title = "This seems to be the first time you are using rtoot. Do you want to authenticate now?",
                default = 2L, verbose = verbose
            )
        }
    } else if (!is_auth_rtoot(token)) {
        selection <- rtoot_menu(
            title = "Your token is invalid. Do you want to authenticate now?", default = 2L,
            verbose = verbose
        )
    }
    if (isTRUE(selection == 1L)) {
        token <- auth_setup()
    } else if (isTRUE(selection == 2L)) {
        stop("No token found. Please run auth_setup() to authenticate.")
    }
    invisible(token)
}
