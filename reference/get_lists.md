# View your lists

Fetch all lists the user owns

## Usage

``` r
get_lists(id = "", token = NULL, parse = TRUE)
```

## Arguments

- id:

  character, either the id of a list to return or "" to show all lists

- token:

  bearer token created with
  [create_token](https://gesistsa.github.io/rtoot/reference/create_token.md)

- parse:

  logical, if `TRUE`, the default, returns a tibble. Use `FALSE` to
  return the "raw" list corresponding to the JSON returned from the
  Mastodon API

## Value

a tibble or list of lists owned by the user

## Examples

``` r
if (FALSE) { # \dontrun{
get_lists()
} # }
```
