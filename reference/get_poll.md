# View a poll

View a polls attached to statuses. To discover poll ID, you will need to
use
[`get_status()`](https://gesistsa.github.io/rtoot/reference/get_status.md)
and look into the `poll`.

## Usage

``` r
get_poll(id, instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE)
```

## Arguments

- id:

  character, ID of the poll in the database

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

a poll

## Examples

``` r
if (FALSE) { # \dontrun{
get_poll(id = "105976")
} # }
```
