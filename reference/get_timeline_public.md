# Get the public timeline

Query the instance for the public timeline

## Usage

``` r
get_timeline_public(
  local = FALSE,
  remote = FALSE,
  only_media = FALSE,
  max_id,
  since_id,
  min_id,
  limit = 20L,
  instance = NULL,
  token = NULL,
  anonymous = FALSE,
  parse = TRUE,
  retryonratelimit = TRUE,
  verbose = TRUE
)
```

## Arguments

- local:

  logical, Show only local statuses?

- remote:

  logical, Show only remote statuses?

- only_media:

  logical, Show only statuses with media attached?

- max_id:

  character or `POSIXct` (date time), Return results older than this id

- since_id:

  character or `POSIXct` (date time), Return results newer than this id

- min_id:

  character or `POSIXct` (date time), Return results immediately newer
  than this id

- limit:

  integer, Maximum number of results to return

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
## as tibble
get_timeline_public()
## as list
get_timeline_public(parse = FALSE)
} # }
```
