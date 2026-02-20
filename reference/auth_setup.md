# Authenticate with a Mastodon instance

Authenticate with a Mastodon instance

## Usage

``` r
auth_setup(
  instance = NULL,
  type = NULL,
  name = NULL,
  path = NULL,
  clipboard = FALSE,
  verbose = TRUE,
  browser = TRUE
)
```

## Arguments

- instance:

  a public instance of Mastodon (e.g., mastodon.social).

- type:

  Either "public" to create a public authentication or "user" to create
  authentication for your user (e.g., if you want to post from R or
  query your followers).

- name:

  give the token a name, in case you want to store more than one.

- path:

  path to store the token in. The default is to store tokens in the path
  returned by `tools::R_user_dir("rtoot", "config")`.

- clipboard:

  logical, whether to export the token to the clipboard

- verbose:

  logical whether to display messages

- browser:

  if `TRUE` (default) a browser window will be opened to authenticate,
  else the URL will be provided so you can copy/paste this into the
  browser yourself

## Value

A bearer token

## Details

If either `name` or `path` are set to `FALSE`, the token is only
returned and not saved. If you would like to save your token as an
environment variable, please set `clipboard` to `TRUE`. Your token will
be copied to clipboard in the environment variable format. Please paste
it into your environment file, e.g. ".Renviron", and restart your R
session.

## See also

[`verify_credentials()`](https://gesistsa.github.io/rtoot/reference/verify_credentials.md),
[`convert_token_to_envvar()`](https://gesistsa.github.io/rtoot/reference/convert_token_to_envvar.md)

## Examples

``` r
if (FALSE) { # \dontrun{
auth_setup("mastodon.social", "public")
} # }
```
