# View statuses above and below this status in the thread

Query the instance for information about the context of a specific
status. A context contains statuses above and below a status in a
thread.

## Usage

``` r
get_context(id, instance = NULL, token = NULL, anonymous = FALSE, parse = TRUE)
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

  logical, if `TRUE`, the default, returns a named list of two tibbles,
  representing the ancestors (statuses above the status) and descendants
  (statuses below the status). Use `FALSE` to return the "raw" list
  corresponding to the JSON returned from the Mastodon API.

## Value

context of a toot as tibble or list

## Examples

``` r
if (FALSE) { # \dontrun{
get_context(id = "109294719267373593", instance = "mastodon.social")
} # }
```
