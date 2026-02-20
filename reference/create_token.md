# get a bearer token for the mastodon api

get a bearer token for the mastodon api

## Usage

``` r
create_token(client, type = "public", browser = TRUE)
```

## Arguments

- client:

  rtoot client object created with
  [get_client](https://gesistsa.github.io/rtoot/reference/get_client.md)

- type:

  one of "public" or "user". See details

- browser:

  if `TRUE` (default) a browser window will be opened to authenticate,
  else the URL will be provided so you can copy/paste this into the
  browser yourself

## Value

a mastodon bearer token

## Details

TBA

## References

https://docs.joinmastodon.org/client/authorized/
