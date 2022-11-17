#' Collect live streams of Mastodon data
#' @name stream_timeline
#' @param timeout Integer, Number of seconds to stream toots for. Stream indefinitely with timeout = Inf. The stream can be interrupted at any time, and file_name will still be a valid file.
#' @param local	 logical, Show only local statuses?
#' @param file_name character, name of file. If not specified, will write to a temporary file stream_toots*.json.
#' @param append logical, if TRUE will append to the end of file_name; if FALSE, will overwrite.
#' @inheritParams get_instance
#' @export
stream_timeline_public <- function(
    timeout = 30,
    local = FALSE,
    file_name = NULL,
    append = TRUE,
    instance = NULL,
    token = NULL,
    anonymous = FALSE,
    parse = TRUE){

  path <- "/api/v1/streaming/public"
  if(isTRUE(local)){
    path <- paste0(path,"/local")
  }
  params <- list()
}

#' @rdname stream_timeline
#' @export
stream_timeline_hashtag <- function(
    hashtag = "rstats",
    timeout = 30,
    local = FALSE,
    file_name = NULL,
    append = TRUE,
    instance = NULL,
    token = NULL,
    anonymous = FALSE,
    parse = TRUE){

  path <- "/api/v1/streaming/hashtag"
  if(isTRUE(local)){
    path <- paste0(path,"/local")
  }
  params = (tag = hashtag)

}

#' @rdname stream_timeline
#' @export
stream_timeline_list <- function(
    list_id,
    timeout = 30,
    file_name = NULL,
    append = TRUE,
    instance = NULL,
    token = NULL,
    anonymous = FALSE,
    parse = TRUE){

  path <- "api/v1/streaming/list"
  params <- list(list = list_id)
}



make_stream_request <- function(timeout,file_name, append, token, path, params,
                                instance = NULL, anonymous = FALSE, ...){
  if (is.null(instance) && anonymous) {
    stop("provide either an instance or a token")
  }
  if (is.null(instance)) {
    token <- check_token_rtoot(token)
    url <- prepare_url(token$instance)
    config <- httr::add_headers(Authorization = paste('Bearer', token$bearer))
  } else {
    url <- prepare_url(instance)
    config = list()
  }
  if(is.null(file_name)){
    file_name <- tempfile(pattern = "stream_toots", fileext = ".json")
  }
  url <- httr::modify_url(url,path = path,query = params)

  #TODO: add handle
  output <- file(file_name)
  con <- curl::curl(url)
  open(output,open = "ab")
  open(con = con, "rb", blocking = FALSE)

  while(isIncomplete(con)){ #TODO add timeout condition, make sure file is written on interrupt
    buf <- readLines(con)
    if(length(buf)){
      line <- buf[grepl("created_at",buf)] # This seems unstable but rtweet does something similar
      line <- gsub("^data:\\s+","",line)
      line <- complete_line(line)
      writeLines(line,output)
    }
  }
  close(con)
  close(outstream)
}

complete_line <- function(line){
  line <- line[grepl("\\}$",line)] #only complete lines
  line <- line[line!=""]
  line
}
