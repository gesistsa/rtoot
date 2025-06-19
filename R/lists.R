#' View your lists
#' @description Fetch all lists the user owns
#' @param id character, either the id of a list to return or "" to show all lists
#' @param token bearer token created with [create_token]
#' @param parse logical, if `TRUE`, the default, returns a tibble. Use `FALSE`  to return the "raw" list corresponding to the JSON returned from the Mastodon API
#' @return a tibble or list of lists owned by the user
#' @examples
#' \dontrun{
#' get_lists()
#' }
#' @export
get_lists <- function(id = "", token = NULL, parse = TRUE) {
    process_request(
        token = token,
        path = paste0("api/v1/lists/", id),
        parse = parse,
        FUN = v(identity)
    )
}

#' Create a list
#' @param title character, The title of the list to be created
#' @param replies_policy character,  One of "followed", "list", or "none". Defaults to "list".
#' @return no return value, called for site effects
#' @inheritParams auth_setup
#' @inheritParams post_toot
#' @examples
#' \dontrun{
#' # create a list
#' post_list_create(title = "test")
#' }
#' @export
post_list_create <- function(
    title,
    replies_policy = "list",
    token = NULL,
    verbose = TRUE
) {
    token <- check_token_rtoot(token)
    replies_policy <- match.arg(replies_policy, c("followed", "list", "none"))
    path <- "/api/v1/lists/"
    params <- list(title = title, replies_policy = replies_policy)

    url <- prepare_url(token$instance)
    r <- httr::POST(
        httr::modify_url(url = url, path = path),
        body = params,
        httr::add_headers(Authorization = paste0("Bearer ", token$bearer))
    )
    if (httr::status_code(r) == 200L) {
        sayif(verbose, paste0("successfully created the list: ", title))
    }
    invisible(r)
}

#' View accounts in a list
#' @param id character, id of the list
#' @param limit integer, number of records to return
#' @param token bearer token created with [create_token]
#' @param parse logical, if `TRUE`, the default, returns a tibble. Use `FALSE`  to return the "raw" list corresponding to the JSON returned from the Mastodon API
#' @param retryonratelimit If TRUE, and a rate limit is exhausted, will wait until it refreshes. Most Mastodon rate limits refresh every 5 minutes. If FALSE, and the rate limit is exceeded, the function will terminate early with a warning; you'll still get back all results received up to that point.
#' @param verbose logical, whether to display messages
#' @return a tibble or list of accounts
#' @examples
#' \dontrun{
#' get_list_accounts(id = "test")
#' }
#' @export
get_list_accounts <- function(
    id,
    limit = 40L,
    token = NULL,
    parse = TRUE,
    retryonratelimit = TRUE,
    verbose = TRUE
) {
    params <- handle_params(list(limit = min(limit, 40L)))
    process_request(
        token = token,
        path = paste0("api/v1/lists/", id, "/accounts"),
        params = params,
        parse = parse,
        FUN = v(parse_account),
        n = limit,
        retryonratelimit = retryonratelimit,
        verbose = verbose
    )
}

#' Add accounts to a list
#' @inheritParams post_list_create
#' @inheritParams get_list_accounts
#' @param account_ids ids of accounts to add (this is not the username)
#' @return no return value, called for site effects
#' @examples
#' \dontrun{
#' # add some accounts to a list
#' post_list_create(id = "1234", account_ids = c(1001, 1002))
#' }
#' @export
post_list_accounts <- function(id, account_ids, token = NULL, verbose = TRUE) {
    token <- check_token_rtoot(token)
    path <- paste0("/api/v1/lists/", id, "/accounts")
    ids_lst <- lapply(account_ids, identity)
    names(ids_lst) <- rep("account_ids[]", length(ids_lst))
    params <- ids_lst

    url <- prepare_url(token$instance)
    r <- httr::POST(
        httr::modify_url(url = url, path = path),
        body = params,
        httr::add_headers(Authorization = paste0("Bearer ", token$bearer))
    )
    if (httr::status_code(r) == 200L) {
        sayif(verbose, paste0("successfully added accounts to list: ", id))
    }
    invisible(r)
}
