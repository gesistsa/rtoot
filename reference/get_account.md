# Query the instance for a specific user

Query the instance for a specific user

## Usage

``` r
get_account(id, instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE)
```

## Arguments

- id:

  character, Local ID of a user (this is not the username)

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

## Value

an account

## Examples

``` r
if (FALSE) { # \dontrun{
get_account("109302436954721982")
} # }
```
