# Get home and list timelines

Query the instance for the timeline from either followed users or a
specific list. These functions can only be called with a user token from
[`create_token()`](https://gesistsa.github.io/rtoot/reference/create_token.md).

## Usage

``` r
get_timeline_home(
  local = FALSE,
  max_id,
  since_id,
  min_id,
  limit = 20L,
  token = NULL,
  parse = TRUE,
  retryonratelimit = TRUE,
  verbose = TRUE
)

get_timeline_list(
  list_id,
  max_id,
  since_id,
  min_id,
  limit = 20L,
  token = NULL,
  parse = TRUE,
  retryonratelimit = TRUE,
  verbose = TRUE
)
```

## Arguments

- local:

  logical, Show only local statuses?

- max_id:

  character or `POSIXct` (date time), Return results older than this id

- since_id:

  character or `POSIXct` (date time), Return results newer than this id

- min_id:

  character or `POSIXct` (date time), Return results immediately newer
  than this id

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

- list_id:

  character, Local ID of the list in the database.

## Value

statuses

## Details

`max_id`, `since_id`, and `min_id` can either be character or `POSIXct`
(date time). If it is `POSXIct`, it will be converted to the so-called
snowflake ID.

## References

https://docs.joinmastodon.org/methods/timelines/

## Examples

``` r
if (FALSE) { # \dontrun{
get_timeline_home()
} # }
if (FALSE) { # \dontrun{
get_timeline_list("<listid>")
} # }
```
