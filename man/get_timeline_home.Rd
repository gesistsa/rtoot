% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/timelines_statuses.R
\name{get_timeline_home}
\alias{get_timeline_home}
\alias{get_timeline_list}
\title{Get home and list timelines}
\usage{
get_timeline_home(
  local = FALSE,
  max_id,
  since_id,
  min_id,
  limit = 20L,
  token = NULL,
  parse = TRUE
)

get_timeline_list(
  list_id,
  max_id,
  since_id,
  min_id,
  limit = 20L,
  token = NULL,
  parse = TRUE
)
}
\arguments{
\item{local}{logical, Show only local statuses?}

\item{max_id}{character, Return results older than this id}

\item{since_id}{character, Return results newer than this id}

\item{min_id}{character, Return results immediately newer than this id}

\item{limit}{integer, Maximum number of results to return}

\item{token}{user bearer token (read from file by default)}

\item{parse}{logical, if \code{TRUE}, the default, returns a tibble. Use \code{FALSE}  to return the "raw" list corresponding to the JSON returned from the Mastodon API.}

\item{list_id}{character, Local ID of the list in the database.}
}
\value{
statuses
}
\description{
Query the instance for the timeline from either followed users or a specific list. These functions can only be called with a user token from \code{\link[=create_token]{create_token()}}.
}
\examples{
\dontrun{
get_timeline_home()
}
\dontrun{
get_timeline_list("<listid>")
}
}
\references{
https://docs.joinmastodon.org/methods/timelines/
}