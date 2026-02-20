# Get statuses from a user

Get statuses from a user

## Usage

``` r
get_account_statuses(
  id,
  max_id,
  since_id,
  min_id,
  limit = 20L,
  exclude_reblogs = FALSE,
  hashtag,
  instance = NULL,
  token = NULL,
  anonymous = FALSE,
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

- min_id:

  character or `POSIXct` (date time), Return results immediately newer
  than this id

- limit:

  integer, Maximum number of results to return

- exclude_reblogs:

  logical, Whether to filter out boosts from the response.

- hashtag:

  character, filter for statuses using a specific hashtag.

- instance:

  character, the server name of the instance where the status is
  located. If `NULL`, the same instance used to obtain the token is
  used.

- token:

  user bearer token (read from file by default)

- anonymous:

  some API calls do not need a token. Setting anonymous to TRUE allows
  to make an anonymous call if possible.

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

tibble or list of statuses

## Details

For anonymous calls only public statuses are returned. If a user token
is supplied also private statuses the user is authorized to see are
returned

## Examples

``` r
if (FALSE) { # \dontrun{
get_account_statuses("109302436954721982")
} # }
```
