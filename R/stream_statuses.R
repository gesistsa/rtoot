#' Collect live streams of Mastodon data
#' @name stream_timeline
#' @param timeout Integer, Number of seconds to stream toots for. Stream indefinitely with timeout = Inf. The stream can be interrupted at any time, and file_name will still be a valid file.
#' @param local	 logical, Show only local statuses (either statuses from your instance or the one provided in `instance`)?
#' @param file_name character, name of file. If not specified, will write to a temporary file stream_toots*.json.
#' @param append logical, if TRUE will append to the end of file_name; if FALSE, will overwrite.
#' @param verbose logical whether to display messages
#' @param list_id character, id of list to stream
#' @param hashtag character, hashtag to stream
#' @inheritParams get_instance
#' @details
#' \describe{
#'   \item{stream_timeline_public}{stream all public statuses on any instance}
#'   \item{stream_timeline_hashtag}{stream all statuses containing a specific hashtag}
#'   \item{stream_timeline_list}{stream the statuses of a list}
#' }
#' @export
#' @examples
#' \dontrun{
#' # stream public timeline for 30 seconds
#' stream_timeline_public(timeout = 30,file_name = "public.json")
#' # stream timeline of mastodon.social  for 30 seconds
#' stream_timeline_public(timeout = 30, local = TRUE,
#'    instance = "mastodon.social", file_name = "social.json")
#'
#' # stream hashtag timeline for 30 seconds
#' stream_timeline_hashtag("rstats", timeout = 30, file_name = "rstats_public.json")
#' # stream hashtag timeline of mastodon.social  for 30 seconds
#' stream_timeline_hashtag("rstats", timeout = 30, local = TRUE,
#'    instance = "fosstodon.org", file_name = "rstats_foss.json")
#' # json files can be parsed with parse_stream()
#' parse_stream("rstats_foss.json")
#' }
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

  quiet_interrupt(
    stream_toots(timeout = timeout, file_name = file_name, append = append, token = token,
                 path = path, params = params, instance = instance, anonymous = anonymous,
                 verbose = verbose)
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
  params <- list(tag = gsub("^#+", "", hashtag))

  quiet_interrupt(
    stream_toots(timeout = timeout, file_name = file_name, append = append, token = token,
                 path = path, params = params, instance = instance, anonymous = anonymous,
                 verbose = verbose)
  )
  invisible(NULL)
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

  quiet_interrupt(
    stream_toots(timeout = timeout, file_name = file_name, append = append, token = token,
                 path = path, params = params, instance = instance, anonymous = anonymous,
                 verbose = verbose)
  )
  invisible(NULL)
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
  if (length(json) == 0) {
    return(tibble::tibble())
  }
  tbl <- dplyr::bind_rows(lapply(json,function(x) parse_status(jsonlite::fromJSON(x))))
  tbl[order(tbl[["created_at"]]),]
}


stream_toots <- function(timeout,file_name = NULL, append, token, path, params,
                                instance = NULL, anonymous = FALSE, verbose = TRUE,...){
  if (!is.numeric(timeout)) stop("timeout must be numeric", call. = FALSE)
  if (timeout<0) stop("timeout must be greater equal 0", call. = FALSE)

  if (is.null(instance) && anonymous) {
    stop("provide either an instance or a token")
  }
  h <- curl::new_handle(verbose = FALSE)
  if (is.null(instance)) {
    token <- check_token_rtoot(token)
    url <- prepare_url(token$instance)
    curl::handle_setheaders(h, "Authorization" = paste0("Bearer ",token$bearer))
  } else {
    url <- prepare_url(instance)
  }

  if(is.null(file_name)){
    file_name <- tempfile(pattern = "stream_toots", fileext = ".json")
    append <- TRUE
  }
  sayif(verbose, "Writing to ",file_name)
  url <- httr::modify_url(url,path = path,query = params)

  stop_time <- Sys.time() + timeout

  output <- file(file_name)
  con <- curl::curl(url,handle = h)
  open(output,open = if (append) "aw" else "w")
  open(con = con, "rb", blocking = FALSE)
  sayif(verbose,"Streaming toots until ",stop_time)
  n_seen <- 0
  while(isIncomplete(con) && Sys.time() < stop_time){
    buf <- readLines(con,warn = FALSE)
    if(length(buf)){
      line <- buf[grepl("created_at",buf)] # This seems unstable but rtweet does something similar
      line <- gsub("^data:\\s+","",line)
      line <- complete_line(line)
      writeLines(line,output)
      n_seen <- n_seen + length(line)
      if (isTRUE(verbose)) {
        cat("streamed toots: ",n_seen,"\r")
      }
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
