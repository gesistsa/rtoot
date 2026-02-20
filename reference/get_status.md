# View information about a specific status

Query the instance for information about a specific status. get_status
returns complete information of a status. get_reblogged_by returns who
boosted a given status. get_favourited_by returns who favourited a given
status.

## Usage

``` r
get_status(id, instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE)

get_reblogged_by(
  id,
  instance = NULL,
  token = NULL,
  anonymous = FALSE,
  parse = TRUE
)

get_favourited_by(
  id,
  instance = NULL,
  token = NULL,
  anonymous = FALSE,
  parse = TRUE
)
```

## Arguments

- id:

  character, local ID of a status in the database

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

a status or a list of users

## Examples

``` r
if (FALSE) { # \dontrun{
get_status(id = "109326579599502650")
get_reblogged_by(id = "109326579599502650")
get_favourited_by(id = "109326579599502650")
} # }
```
