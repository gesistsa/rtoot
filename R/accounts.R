#' Query the instance for a specific user
#'
#' @param id character, Local ID of a user (this is not the username)
#' @inheritParams get_status
#' @inheritParams post_toot
#' @return an account
#' @export
get_account <- function(id,instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE){
  path <- paste0("api/v1/accounts/",id)
  params <- list()
  output <- make_get_request(token = token,path = path,
                                      instance = instance, params = params,
                                      anonymous = anonymous)
  if (isTRUE(parse)) {
    output <- parse_account(output)
  }
  return(output)
}

#' Search the instance for a specific user
#'
#' @param query character, search string
#' @param limit number of search results to return. Defaults to 40
#' @inheritParams get_status
#' @inheritParams post_toot
#' @return accounts
#' @export
search_accounts <- function(query,limit = 40,instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE){
  path <- "/api/v1/accounts/search"
  params <- list(q=query,limit = limit)
  output <- make_get_request(token = token,path = path,
                                      instance = instance, params = params,
                                      anonymous = anonymous)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(lapply(output, parse_account))
  }
  return(output)
}

#' Get statuses from a user
#'
#' @param id character, local ID of a user (this is not the username)
#' @inheritParams get_status
#' @inheritParams post_toot
#' @details  For anonymous calls only public statuses are returned. If a user token is supplied also private statuses the user is authorized to see are returned
#' @return statuses
#' @export
get_account_statuses <- function(id,instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/statuses")
  params <- list()
  output <- make_get_request(token = token,path = path,
                             instance = instance, params = params,
                             anonymous = anonymous)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(lapply(output, parse_status))
  }
  return(output)
}

#' Get followers of a user
#' @inheritParams get_account_statuses
#' @param max_id character, Return results older than this id
#' @param since_id character, Return results newer than this id
#' @param limit integer, maximum number of results to return. Defaults to 40.
#' @details this functions needs a user level auth token
#' @return followers
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
  output <- make_get_request(token = token, path = path, params = params)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(lapply(output, parse_account))
  }
  return(output)
}
#' Get accounts a user follows
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @details this functions needs a user level auth token
#' @return followers
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
  output <- make_get_request(token = token, path = path, params = params)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(lapply(output, parse_account))
  }
  return(output)
}

#' Get featured tags of a user
#' @inheritParams get_account_statuses
#' @details this functions needs a user level auth token
#' @return featured_tags
#' @export
get_account_featured_tags <- function(id,token = NULL, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/featured_tags")
  params <- list()
  output <- make_get_request(token = token,path = path, params = params)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(output)
  }
  return(output)
}

#' Get lists containing the user
#' @inheritParams get_account_statuses
#' @details this functions needs a user level auth token
#' @return lists
#' @export
get_account_lists <- function(id,token = NULL, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/lists")
  params <- list()
  output <- make_get_request(token = token,path = path, params = params)
  if (isTRUE(parse)) {
    # output <- dplyr::bind_rows(lapply(output, parse_status))
  }
  return(output) #TODO: probably need to format
}

#' Find out whether a given account is followed, blocked, muted, etc.
#' @inheritParams get_account_statuses
#' @param ids vector of account ids
#' @details this functions needs a user level auth token
#' @return relationships
#' @export
get_account_relationships <- function(ids,token = NULL, parse = TRUE){
  path <- "/api/v1/accounts/relationships"
  ids_lst <- lapply(ids,identity)
  names(ids_lst) <- rep("id[]",length(ids_lst))
  params <- ids_lst
  output <- make_get_request(token = token,path = path, params = params)
  dplyr::bind_rows(output)
}


#' Get bookmarks of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @param min_id character, Return results younger than this id
#' @details this functions needs a user level auth token
#' @return bookmarked statuses
#' @export
get_account_bookmarks <- function(id,max_id,since_id,min_id,limit = 40, token = NULL, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/bookmarks")
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
  output <- make_get_request(token = token, path = path, params = params)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(lapply(output, parse_status))
  }
  return(output)
}

#' Get favourites of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @param min_id character, Return results younger than this id
#' @details this functions needs a user level auth token
#' @return favourited statuses
#' @export
get_account_favourites <- function(id,max_id,min_id,limit = 40, token = NULL, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/favourites")
  params <- list(limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(min_id)) {
    params$min_id <- min_id
  }
  output <- make_get_request(token = token, path = path, params = params)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(lapply(output, parse_status))
  }
  return(output)
}

#' Get blocks of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @details this functions needs a user level auth token
#' @return blocked users
#' @export
get_account_blocks <- function(id,max_id,since_id,limit = 40, token = NULL, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/blocks")
  params <- list(limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(since_id)) {
    params$since_id <- since_id
  }
  output <- make_get_request(token = token, path = path, params = params)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(lapply(output, parse_account))
  }
  return(output)
}

#' Get mutes of user
#' @inheritParams get_account_statuses
#' @inheritParams get_account_followers
#' @details this functions needs a user level auth token
#' @return muted users
#' @export
get_account_mutes <- function(id,max_id,since_id,limit = 40, token = NULL, parse = TRUE){
  path <- paste0("api/v1/accounts/",id,"/mutes")
  params <- list(limit = limit)
  if (!missing(max_id)) {
    params$max_id <- max_id
  }
  if (!missing(since_id)) {
    params$since_id <- since_id
  }
  output <- make_get_request(token = token, path = path, params = params)
  if (isTRUE(parse)) {
    output <- dplyr::bind_rows(lapply(output, parse_account))
  }
  return(output)
}
