# Get accounts a user follows

Get accounts a user follows

## Usage

``` r
get_account_following(
  id,
  max_id,
  since_id,
  limit = 40L,
  token = NULL,
  parse = TRUE,
  retryonratelimit = TRUE,
  verbose = TRUE
)
```

## Arguments

- id:

  character, local ID of a user (this is not the username)

- max_id:

  character or `POSIXct` (date time), Return results older than this id

- since_id:

  character or `POSIXct` (date time), Return results newer than this id

- limit:

  integer, Maximum number of results to return

- token:

  user bearer token (read from file by default)

- parse:

  logical, if `TRUE`, the default, returns a tibble. Use `FALSE` to
  return the "raw" list corresponding to the JSON returned from the
  Mastodon API.

- retryonratelimit:

  If TRUE, and a rate limit is exhausted, will wait until it refreshes.
  Most Mastodon rate limits refresh every 5 minutes. If FALSE, and the
  rate limit is exceeded, the function will terminate early with a
  warning; you'll still get back all results received up to that point.

- verbose:

  logical whether to display messages

## Value

tibble or list of accounts a user follows

## Details

this functions needs a user level auth token. If limit\>40, automatic
pagination is used. You may get more results than requested.

## Examples

``` r
if (FALSE) { # \dontrun{
get_account_following("109302436954721982")
} # }
```
