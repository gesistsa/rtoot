# Query Mastodon API

This is a minimalistic interface for querying the Mastodon API. This
function is for advanced users who want to query the Mastodon API for
endpoints that the R functions are not yet implemented. Please also note
that the API responses will not be parsed as tibble. Refer to the
official API documentation for endpoints and parameters.

## Usage

``` r
rtoot(
  endpoint,
  ...,
  params = list(),
  token = NULL,
  instance = NULL,
  anonymous = FALSE
)
```

## Arguments

- endpoint:

  character, a Mastodon API endpoint. Currently, only endpoints using
  GET are supported

- ...:

  Name-value pairs giving API parameters.

- params:

  list, API parameters to be submitted

- token:

  user bearer token (read from file by default)

- instance:

  character, the server name of the instance where the status is
  located. If `NULL`, the same instance used to obtain the token is
  used.

- anonymous:

  some API calls do not need a token. Setting anonymous to TRUE allows
  to make an anonymous call if possible.

## Value

a list

## References

https://docs.joinmastodon.org/methods/

## Examples

``` r
if (FALSE) { # \dontrun{
rtoot(endpoint = "api/v1/notifications")
rtoot(endpoint = "api/v1/notifications", limit = 8)
## same
rtoot(endpoint = "api/v1/notifications", params = list(limit = 8))
rtoot(endpoint = "api/v1/followed_tags")
## reimplement `get_timeline_public`
rtoot(
  endpoint = "api/v1/timelines/public",
  instance = "mastodon.social",
  local = TRUE,
  anonymous = TRUE
)
} # }
```
