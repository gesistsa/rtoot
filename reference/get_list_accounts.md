# View accounts in a list

View accounts in a list

## Usage

``` r
get_list_accounts(
  id,
  limit = 40L,
  token = NULL,
  parse = TRUE,
  retryonratelimit = TRUE,
  verbose = TRUE
)
```

## Arguments

- id:

  character, id of the list

- limit:

  integer, number of records to return

- token:

  bearer token created with
  [create_token](https://gesistsa.github.io/rtoot/reference/create_token.md)

- parse:

  logical, if `TRUE`, the default, returns a tibble. Use `FALSE` to
  return the "raw" list corresponding to the JSON returned from the
  Mastodon API

- retryonratelimit:

  If TRUE, and a rate limit is exhausted, will wait until it refreshes.
  Most Mastodon rate limits refresh every 5 minutes. If FALSE, and the
  rate limit is exceeded, the function will terminate early with a
  warning; you'll still get back all results received up to that point.

- verbose:

  logical, whether to display messages

## Value

a tibble or list of accounts

## Examples

``` r
if (FALSE) { # \dontrun{
get_list_accounts(id = "test")
} # }
```
