# Find out whether a given account is followed, blocked, muted, etc.

Find out whether a given account is followed, blocked, muted, etc.

## Usage

``` r
get_account_relationships(ids, token = NULL, parse = TRUE)
```

## Arguments

- ids:

  vector of account ids

- token:

  user bearer token (read from file by default)

- parse:

  logical, if `TRUE`, the default, returns a tibble. Use `FALSE` to
  return the "raw" list corresponding to the JSON returned from the
  Mastodon API.

## Value

tibble or list of relationships

## Details

this functions needs a user level auth token

## Examples

``` r
if (FALSE) { # \dontrun{
fol <- get_account_followers("109302436954721982")
get_account_relationships(fol$id)
} # }
```
