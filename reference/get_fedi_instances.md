# Get a list of fediverse servers

Get a list of fediverse servers

## Usage

``` r
get_fedi_instances(token = NA, n = 20, ...)
```

## Arguments

- token:

  token from instances.social (this is different from your Mastodon
  token!)

- n:

  number of servers to show

- ...:

  additional parameters for the instances.social API. See
  <https://instances.social/api/doc/>

## Value

tibble of fediverse instances

## Details

This function uses the API at instances.social and needs a separate
token. Results are sorted by number of users

## Examples

``` r
if (FALSE) { # \dontrun{
get_fedi_instances(n = 5)
} # }
```
