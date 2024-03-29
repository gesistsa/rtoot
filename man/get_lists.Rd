% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lists.R
\name{get_lists}
\alias{get_lists}
\title{View your lists}
\usage{
get_lists(id = "", token = NULL, parse = TRUE)
}
\arguments{
\item{id}{character, either the id of a list to return or "" to show all lists}

\item{token}{bearer token created with \link{create_token}}

\item{parse}{logical, if \code{TRUE}, the default, returns a tibble. Use \code{FALSE}  to return the "raw" list corresponding to the JSON returned from the Mastodon API}
}
\value{
a tibble or list of lists owned by the user
}
\description{
Fetch all lists the user owns
}
\examples{
\dontrun{
get_lists()
}
}
