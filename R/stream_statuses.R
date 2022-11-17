#' Collect live streams of Mastodon data
#' @name stream_timeline
#' @param timeout Integer, Number of seconds to stream toots for. Stream indefinitely with timeout = Inf. The stream can be interrupted at any time, and file_name will still be a valid file.
#' @param local	 logical, Show only local statuses?
#' @param file_name character, name of file. If not specified, will write to a temporary file stream_toots*.json.
#' @param append logical, if TRUE will append to the end of file_name; if FALSE, will overwrite.
#' @param verbose logical whether to display messages
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
    verbose = TRUE){

  path <- "/api/v1/streaming/public"
  if(isTRUE(local)){
    path <- paste0(path,"/local")
  }
  params <- list()

  if(is.null(file_name)){
    file_name <- tempfile(pattern = "stream_toots", fileext = ".json")
  }

  quiet_interrupt(
    stream_toots(timeout,file_name, append, token, path, params, instance, anonymous)
  )
  invisible(NULL)
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
    verbose = TRUE){

  path <- "/api/v1/streaming/hashtag"
  if(isTRUE(local)){
    path <- paste0(path,"/local")
  }
  params = (tag = hashtag)

  if(is.null(file_name)){
    file_name <- tempfile(pattern = "stream_toots", fileext = ".json")
  }
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
    verbose = TRUE){

  path <- "api/v1/streaming/list"
  params <- list(list = list_id)

  if(is.null(file_name)){
    file_name <- tempfile(pattern = "stream_toots", fileext = ".json")
  }
}

#' Parser of Mastodon stream
#'
#' Converts Mastodon stream data (JSON file) into parsed tibble.
#' @param path Character, name of JSON file with data collected by any [stream_timeline] function.
#' @export
#' @seealso `stream_timeline_public()`, `stream_timeline_hashtag()`,`stream_timeline_list()`
#' @examples
#' \dontrun{
#' stream_timeline_public(1,file_name = "stream.json")
#' parse_stream("stream.json")
#' }
parse_stream <- function(path){
  json <- readLines(path)
  tbl <- dplyr::bind_rows(lapply(json,function(x) parse_status(jsonlite::fromJSON(x))))
  dplyr::arrange(tbl,created_at)

}


stream_toots <- function(timeout,file_name = NULL, append, token, path, params,
                                instance = NULL, anonymous = FALSE, verbose = TRUE,...){
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

  url <- httr::modify_url(url,path = path,query = params)

  stopifnot(is.numeric(timeout), timeout > 0)
  stop_time <- Sys.time() + timeout

  #TODO: add handle with bearer
  output <- file(file_name)
  con <- curl::curl(url)
  open(output,open = if (append) "ab" else "b")
  open(con = con, "rb", blocking = FALSE)

  while(isIncomplete(con) && Sys.time() < stop_time){
    buf <- readLines(con)
    if(length(buf)){
      line <- buf[grepl("created_at",buf)] # This seems unstable but rtweet does something similar
      line <- gsub("^data:\\s+","",line)
      line <- complete_line(line)
      writeLines(line,output)
    }
  }
  on.exit({
    close(con)
    close(output)
  })
  invisible()
}

complete_line <- function(line){
  line <- line[grepl("\\}$",line)] #delete incomplete lines
  line <- line[line!=""] # delete empty lines
  line
}

quiet_interrupt <- function(code) {
  tryCatch(code, interrupt = function(e) NULL)
}
