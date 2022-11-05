#' Get a list of fediverse servers
#'
#' @param n number of servers to show
#' @details the results are sorted by user count
#' @return data frame of fediverse instances
#' @export
get_instances  <-  function(n = 20) {
  pages <- ceiling(n/20)
  df <- data.frame()
  for(i in seq_along(pages)){
    tmp <- jsonlite::fromJSON("https://api.index.community/api/instances?sortField=userCount&sortDirection=desc&page=",i)$instances
    df <- rbind(df,as.data.frame(do.call(rbind, lapply(tmp, rbind))))
  }
  df[1:n,]
}


