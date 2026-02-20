# Get lists containing the user

Get lists containing the user

## Usage

``` r
get_account_lists(id, token = NULL, parse = TRUE)
```

## Arguments

- id:

  character, local ID of a user (this is not the username)

- token:

  user bearer token (read from file by default)

- parse:

  logical, if `TRUE`, the default, returns a tibble. Use `FALSE` to
  return the "raw" list corresponding to the JSON returned from the
  Mastodon API.

## Value

tibble or list of lists

## Details

this functions needs a user level auth token

## Examples

``` r
if (FALSE) { # \dontrun{
get_account_lists("109302436954721982")
} # }
```
