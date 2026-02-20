# Convert token to environment variable

Convert token to environment variable

## Usage

``` r
convert_token_to_envvar(token, clipboard = TRUE, verbose = TRUE)
```

## Arguments

- token:

  bearer token, either public or user level

- clipboard:

  logical, whether to export the token to the clipboard

- verbose:

  logical whether to display messages

## Value

Token (in environment variable format), invisibily

## Examples

``` r
if (FALSE) { # \dontrun{
x <- auth_setup("mastodon.social", "public")
envvar <- convert_token_to_envvar(x)
envvar
} # }
```
