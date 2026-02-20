# Search the instance for a specific user

Search the instance for a specific user

## Usage

``` r
search_accounts(
  query,
  limit = 40,
  token = NULL,
  anonymous = FALSE,
  parse = TRUE
)
```

## Arguments

- query:

  character, search string

- limit:

  number of search results to return. Defaults to 40

- token:

  user bearer token (read from file by default)

- anonymous:

  some API calls do not need a token. Setting anonymous to TRUE allows
  to make an anonymous call if possible.

- parse:

  logical, if `TRUE`, the default, returns a tibble. Use `FALSE` to
  return the "raw" list corresponding to the JSON returned from the
  Mastodon API.

## Value

a tibble ir list of accounts

## Examples

``` r
if (FALSE) { # \dontrun{
search_accounts("schochastics")
} # }
```
