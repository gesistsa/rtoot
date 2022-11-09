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
get_account <- function(id,instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE){
  path <- paste0("api/v1/accounts/",id)
  params <- list()

  process_request(token = token,path = path,instance = instance,
                  params = params, anonymous = anonymous,
                  parse = parse, FUN = parse_account)
}

#' Search the instance for a specific user
#'
#' @param query character, search string
#' @param limit number of search results to return. Defaults to 40
#' @inheritParams get_status
#' @inheritParams post_toot
#' @return a tibble ir list of accounts
#' #' @examples
#' \dontrun{
#' search_accounts("schochastics")
#' }
#' @export
search_accounts <- function(query,limit = 40,instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE){
  path <- "/api/v1/accounts/search"
  params <- list(q=query,limit = limit)

  process_request(token = token,path = path,instance = instance,
                  params = params, anonymous = anonymous,
                  parse = parse, FUN = v(parse_account))
}

#' Get statuses from a user
#'
#' @param id character, local ID of a user (this is not the username)
#' @inheritParams get_status
#' @inheritParams post_toot
#' @details  For anonymous calls only public statuses are returned. If a user token is supplied also private statuses the user is authorized to see are returned
#' @return tibble or list of statuses
#' @export
#' @examples
#' \dontrun{
#' get_account_statuses("109302436954721982")
#' }
get_account_statuses <- function(id,instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/statuses")
  params <- list()

  process_request(token = token,path = path,instance = instance,
                  params = params, anonymous = anonymous,
                  parse = parse, FUN = v(parse_status))
}

#' Get followers of a user
#' @inheritParams get_account_statuses
#' @param max_id character, Return results older than this id
#' @param since_id character, Return results newer than this id
#' @param limit integer, maximum number of results to return. Defaults to 40.
#' @details this functions needs a user level auth token
#' @return tibble or list of followers
#' @export
get_account_followers <- function(id,max_id,since_id,limit = 40, token = NULL, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/followers")
  params <- list(limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(since_id)) {
    params$since_id <- since_id
  }
  process_request(token = token,path = path,
                  params = params,
                  parse = parse, FUN = v(parse_account))
}
#' Get accounts a user follows
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @details this functions needs a user level auth token
#' @return tibble or list of accounts a user follows
#' @export
get_account_following <- function(id,max_id,since_id,limit = 40, token = NULL, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/following")
  params <- list(limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(since_id)) {
    params$since_id <- since_id
  }

  process_request(token = token,path = path,
                  params = params,
                  parse = parse, FUN = v(parse_account))
}

#' Get featured tags of a user
#' @inheritParams get_account_statuses
#' @details this functions needs a user level auth token
#' @return tibble or list of featured_tags
#' @export
get_account_featured_tags <- function(id,token = NULL, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/featured_tags")
  params <- list()

  process_request(token = token,path = path,
                  params = params,
                  parse = parse, FUN = v(identity))
}

#' Get lists containing the user
#' @inheritParams get_account_statuses
#' @details this functions needs a user level auth token
#' @return tibble or list of lists
#' @export
get_account_lists <- function(id,token = NULL, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/lists")
  params <- list()

  process_request(token = token,path = path,
                  params = params,
                  parse = parse, FUN = v(identity))
}

#' Find out whether a given account is followed, blocked, muted, etc.
#' @inheritParams get_account_statuses
#' @param ids vector of account ids
#' @details this functions needs a user level auth token
#' @return tibble or list of relationships
#' @export
get_account_relationships <- function(ids,token = NULL, parse = TRUE){
  path <- "/api/v1/accounts/relationships"
  ids_lst <- lapply(ids,identity)
  names(ids_lst) <- rep("id[]",length(ids_lst))
  params <- ids_lst

  process_request(token = token,path = path,
                  params = params,
                  parse = parse, FUN = v(identity))
}


#' Get bookmarks of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @param min_id character, Return results younger than this id
#' @details this functions needs a user level auth token
#' @return bookmarked statuses
#' @export
get_account_bookmarks <- function(max_id,since_id,min_id,limit = 40, token = NULL, parse = TRUE){
  path <- paste0("api/v1/bookmarks")
  params <- list(limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(since_id)) {
    params$since_id <- since_id
  }
  if (!missing(min_id)) {
    params$since_id <- min_id
  }

  process_request(token = token,path = path,
                  params = params,
                  parse = parse, FUN = v(parse_status))
}

#' Get favourites of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @param min_id character, Return results younger than this id
#' @details this functions needs a user level auth token
#' @return tibble or list of favourited statuses
#' @export
get_account_favourites <- function(max_id,min_id,limit = 40, token = NULL, parse = TRUE){
  path <- paste0("api/v1/favourites")
  params <- list(limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(min_id)) {
    params$min_id <- min_id
  }

  process_request(token = token,path = path,
                  params = params,
                  parse = parse, FUN = v(parse_status))
}

#' Get blocks of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @details this functions needs a user level auth token
#' @return tibble or list of blocked users
#' @export
get_account_blocks <- function(max_id,since_id,limit = 40, token = NULL, parse = TRUE){
  path <- paste0("api/v1/blocks")
  params <- list(limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(since_id)) {
    params$since_id <- since_id
  }

  process_request(token = token,path = path,
                  params = params,
                  parse = parse, FUN = v(parse_account))
}

#' Get mutes of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @details this functions needs a user level auth token
#' @return tibble or list of muted users
#' @export
get_account_mutes <- function(max_id,since_id,limit = 40, token = NULL, parse = TRUE){
  path <- paste0("api/v1/mutes")
  params <- list(limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(since_id)) {
    params$since_id <- since_id
  }

  process_request(token = token,path = path,
                  params = params,
                  parse = parse, FUN = v(parse_account))
}
