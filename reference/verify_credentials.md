# Verify mastodon credentials

Verify mastodon credentials

## Usage

``` r
verify_credentials(token, verbose = TRUE)

verify_envvar(verbose = TRUE)
```

## Arguments

- token:

  bearer token, either public or user level

- verbose:

  logical whether to display messages

## Value

Raise an error if the token is not valid. Return the response from the
verification API invisibly otherwise.

## Details

If you have created your token as an environment variable, use
`verify_envvar` to verify your token.

## Examples

``` r
if (FALSE) { # \dontrun{
# read a token from a file
verify_credentials(token)
} # }
```
