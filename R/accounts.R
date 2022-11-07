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
}

#' Search the instance for a specific user
#'
#' @param query character, search string
#' @param limit numbre of search results to return. Defaults to 40
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
