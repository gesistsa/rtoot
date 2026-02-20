# Get various information about a specific instance

Get various information about a specific instance

## Usage

``` r
get_instance_general(instance = NULL, token = NULL, anonymous = TRUE)

get_instance_peers(instance = NULL, token = NULL, anonymous = TRUE)

get_instance_activity(instance = NULL, token = NULL, anonymous = TRUE)

get_instance_emoji(instance = NULL, token = NULL, anonymous = TRUE)

get_instance_directory(
  instance = NULL,
  token = NULL,
  offset = 0,
  limit = 40,
  order = "active",
  local = FALSE,
  anonymous = TRUE,
  parse = TRUE
)

get_instance_trends(
  instance = NULL,
  token = NULL,
  limit = 10,
  anonymous = TRUE
)

get_instance_rules(instance = NULL, token = NULL, anonymous = FALSE)

get_instance_blocks(instance = NULL, token = NULL, anonymous = TRUE)
```

## Arguments

- instance:

  character, the server name of the instance where the status is
  located. If `NULL`, the same instance used to obtain the token is
  used.

- token:

  user bearer token (read from file by default)

- anonymous:

  logical, should the API call be made anonymously? Defaults to TRUE but
  some instances might need authentication here

- offset:

  How many accounts to skip before returning results. Default 0.

- limit:

  integer, Maximum number of results to return

- order:

  'active' to sort by most recently posted statuses (default) or 'new'
  to sort by most recently created profiles.

- local:

  logical, show only local accounts?

- parse:

  logical, if `TRUE`, the default, returns a tibble. Use `FALSE` to
  return the "raw" list corresponding to the JSON returned from the
  Mastodon API.

## Value

instance details as list or tibble depending on call function

## Details

- get_instance_general:

  Returns general information about the instance

- get_instance_peers:

  Returns the peers of an instance

- get_instance_activity:

  Shows the weekly activity of the instance (3 months)

- get_instance_emoji:

  Lists custom emojis available on the instance

- get_instance_directory:

  A directory of profiles that the instance is aware of

- get_instance_trends:

  Tags that are being used more frequently within the past week

- get_instance_rules:

  Prints the rules of an instance

- get_instance_blocks:

  List of domains that are blocked by an instance.

## Examples

``` r
if (FALSE) { # \dontrun{
 get_instance_general("mastodon.social")
 get_instance_activity("mastodon.social")
 get_instance_emoji("mastodon.social")
 get_instance_peers("mastodon.social")
 get_instance_directory("mastodon.social",limit = 2)
} # }
```
