#' Query the instance for a specific user
#'
#' @param id character, Local ID of a user (this is not the username)
#' @inheritParams get_status
#' @inheritParams post_toot
#' @return an account
#' @examples
#' \dontrun{
#' get_account("109302436954721982")
#' }
#' @export
get_account <- function(id, instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE) {
    process_request(
        token = token, path = paste0("api/v1/accounts/", id), instance = instance,
        anonymous = anonymous,
        parse = parse, FUN = parse_account
    )
}

#' Search the instance for a specific user
#'
#' @param query character, search string
#' @param limit number of search results to return. Defaults to 40
#' @inheritParams get_status
#' @inheritParams post_toot
#' @return a tibble ir list of accounts
#' @examples
#' \dontrun{
#' search_accounts("schochastics")
#' }
#' @export
search_accounts <- function(query, limit = 40, token = NULL, anonymous = FALSE, parse = TRUE) {
    params <- list(q = query, limit = limit)
    process_request(
        token = token, path = "/api/v1/accounts/search", instance = NULL,
        params = params, anonymous = anonymous,
        parse = parse, FUN = v(parse_account)
    )
}

#' Get statuses from a user
#'
#' @param id character, local ID of a user (this is not the username)
#' @inheritParams get_status
#' @inheritParams post_toot
#' @inheritParams get_timeline_home
#' @param exclude_reblogs logical, Whether to filter out boosts from the response.
#' @param hashtag character, filter for statuses using a specific hashtag.
#' @param retryonratelimit If TRUE, and a rate limit is exhausted, will wait until it refreshes. Most Mastodon rate limits refresh every 5 minutes. If FALSE, and the rate limit is exceeded, the function will terminate early with a warning; you'll still get back all results received up to that point.
#' @details  For anonymous calls only public statuses are returned. If a user token is supplied also private statuses the user is authorized to see are returned
#' @return tibble or list of statuses
#' @examples
#' \dontrun{
#' get_account_statuses("109302436954721982")
#' }
#' @export
get_account_statuses <- function(id, max_id, since_id, min_id, limit = 20L,
                                 exclude_reblogs = FALSE, hashtag,
                                 instance = NULL,
                                 token = NULL,
                                 anonymous = FALSE,
                                 parse = TRUE,
                                 retryonratelimit = TRUE, verbose = TRUE) {
    params <- handle_params(list(limit = min(limit, 20L), exclude_reblogs = exclude_reblogs), max_id, since_id, min_id)
    if (!missing(hashtag)) {
        params$tagged <- gsub("^#+", "", hashtag)
    }
    process_request(
        token = token, path = paste0("api/v1/accounts/", id, "/statuses"),
        instance = instance,
        params = params, anonymous = anonymous,
        parse = parse, FUN = v(parse_status),
        n = limit, page_size = 20L,
        retryonratelimit = retryonratelimit,
        verbose = verbose
    )
}

#' Get followers of a user
#' @inheritParams get_account_statuses
#' @param max_id character, Return results older than this id
#' @param since_id character, Return results newer than this id
#' @param limit integer, maximum number of results to return. Defaults to 40.
#' @param retryonratelimit If TRUE, and a rate limit is exhausted, will wait until it refreshes. Most Mastodon rate limits refresh every 5 minutes. If FALSE, and the rate limit is exceeded, the function will terminate early with a warning; you'll still get back all results received up to that point.
#' @inheritParams auth_setup
#' @details this functions needs a user level auth token. If limit>40, automatic pagination is used. You may get more results than requested.
#' @return tibble or list of followers
#' @examples
#' \dontrun{
#' get_account_followers("109302436954721982")
#' }
#' @export
get_account_followers <- function(id, max_id, since_id,
                                  limit = 40L,
                                  token = NULL,
                                  parse = TRUE,
                                  retryonratelimit = TRUE,
                                  verbose = TRUE) {
    params <- handle_params(list(limit = min(limit, 40L)), max_id, since_id)
    process_request(
        token = token, path = paste0("api/v1/accounts/", id, "/followers"),
        params = params,
        parse = parse, FUN = v(parse_account),
        n = limit, retryonratelimit = retryonratelimit,
        verbose = verbose
    )
}
#' Get accounts a user follows
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @inheritParams auth_setup
#' @inherit get_account_followers details
#' @return tibble or list of accounts a user follows
#' @examples
#' \dontrun{
#' get_account_following("109302436954721982")
#' }
#' @export
get_account_following <- function(id, max_id, since_id, limit = 40L,
                                  token = NULL, parse = TRUE,
                                  retryonratelimit = TRUE,
                                  verbose = TRUE) {
    params <- handle_params(list(limit = min(limit, 40L)), max_id, since_id)
    process_request(
        token = token, path = paste0("api/v1/accounts/", id, "/following"),
        params = params,
        parse = parse, FUN = v(parse_account),
        n = limit, retryonratelimit = retryonratelimit, verbose = verbose
    )
}

#' Get featured tags of a user
#' @inheritParams get_account_statuses
#' @details this functions needs a user level auth token
#' @return tibble or list of featured_tags
#' @examples
#' \dontrun{
#' get_account_featured_tags("109302436954721982")
#' }
#' @export
get_account_featured_tags <- function(id, token = NULL, parse = TRUE) {
    process_request(
        token = token, path = paste0("api/v1/accounts/", id, "/featured_tags"),
        parse = parse, FUN = v(identity)
    )
}

#' Get lists containing the user
#' @inheritParams get_account_statuses
#' @details this functions needs a user level auth token
#' @return tibble or list of lists
#' @examples
#' \dontrun{
#' get_account_lists("109302436954721982")
#' }
#' @export
get_account_lists <- function(id, token = NULL, parse = TRUE) {
    process_request(
        token = token, path = paste0("api/v1/accounts/", id, "/lists"),
        parse = parse, FUN = v(identity)
    )
}

#' Find out whether a given account is followed, blocked, muted, etc.
#' @inheritParams get_account_statuses
#' @param ids vector of account ids
#' @details this functions needs a user level auth token
#' @return tibble or list of relationships
#' @examples
#' \dontrun{
#' fol <- get_account_followers("109302436954721982")
#' get_account_relationships(fol$id)
#' }
#' @export
get_account_relationships <- function(ids, token = NULL, parse = TRUE) {
    ids_lst <- lapply(ids, identity)
    names(ids_lst) <- rep("id[]", length(ids_lst))
    params <- ids_lst
    process_request(
        token = token, path = "/api/v1/accounts/relationships",
        params = params,
        parse = parse, FUN = v(identity)
    )
}

#' Get bookmarks of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @inheritParams auth_setup
#' @param min_id character, Return results younger than this id
#' @inherit get_account_followers details
#' @return bookmarked statuses
#' @examples
#' \dontrun{
#' get_account_followers("109302436954721982")
#' }
#' @export
get_account_bookmarks <- function(max_id, since_id, min_id, limit = 40L,
                                  token = NULL, parse = TRUE,
                                  retryonratelimit = TRUE,
                                  verbose = TRUE) {
    params <- handle_params(list(limit = min(limit, 40L)), max_id, since_id, min_id)
    process_request(
        token = token, path = "api/v1/bookmarks",
        params = params,
        parse = parse, FUN = v(parse_status), n = limit,
        retryonratelimit = retryonratelimit, verbose = verbose
    )
}

#' Get favourites of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @inheritParams auth_setup
#' @param min_id character, Return results younger than this id
#' @inherit get_account_followers details
#' @return tibble or list of favourited statuses
#' @examples
#' \dontrun{
#' # needs user level token
#' get_account_favourites()
#' }
#' @export
get_account_favourites <- function(max_id, min_id, limit = 40L,
                                   token = NULL, parse = TRUE,
                                   retryonratelimit = TRUE,
                                   verbose = TRUE) {
    params <- handle_params(list(limit = min(limit, 40L)), max_id = max_id, min_id = min_id)
    process_request(
        token = token, path = "api/v1/favourites",
        params = params,
        parse = parse, FUN = v(parse_status), n = limit,
        retryonratelimit = retryonratelimit, verbose = verbose
    )
}

#' Get blocks of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @inheritParams auth_setup
#' @inherit get_account_followers details
#' @return tibble or list of blocked users
#' @examples
#' \dontrun{
#' # needs user level token
#' get_account_blocks()
#' }
#' @export
get_account_blocks <- function(max_id, since_id, limit = 40L,
                               token = NULL, parse = TRUE,
                               retryonratelimit = TRUE,
                               verbose = TRUE) {
    params <- handle_params(list(limit = min(limit, 40L)), max_id, since_id)
    process_request(
        token = token, path = "api/v1/blocks",
        params = params,
        parse = parse, FUN = v(parse_account), n = limit,
        retryonratelimit = retryonratelimit, verbose = verbose
    )
}

#' Get mutes of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @inheritParams auth_setup
#' @inherit get_account_followers details
#' @return tibble or list of muted users
#' @examples
#' \dontrun{
#' # needs user level token
#' get_account_mutes()
#' }
#' @export
get_account_mutes <- function(max_id, since_id, limit = 40L,
                              token = NULL, parse = TRUE,
                              retryonratelimit = TRUE,
                              verbose = TRUE) {
    params <- handle_params(list(limit = min(limit, 40L)), max_id, since_id)
    process_request(
        token = token, path = "api/v1/mutes",
        params = params,
        parse = parse, FUN = v(parse_account),
        n = limit, retryonratelimit = retryonratelimit,
        verbose = verbose
    )
}
