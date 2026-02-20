# Parser of Mastodon stream

Converts Mastodon stream data (JSON file) into a parsed tibble.

## Usage

``` r
parse_stream(path)
```

## Arguments

- path:

  Character, name of JSON file with data collected by any
  [stream_timeline](https://gesistsa.github.io/rtoot/reference/stream_timeline.md)
  function.

## Value

a tibble of statuses

## Details

The stream sometimes returns invalid lines of json. These are
automatically skipped. Parsing can be slow if your json contains a large
amount of statuses

## See also

[`stream_timeline_public()`](https://gesistsa.github.io/rtoot/reference/stream_timeline.md),
[`stream_timeline_hashtag()`](https://gesistsa.github.io/rtoot/reference/stream_timeline.md),[`stream_timeline_list()`](https://gesistsa.github.io/rtoot/reference/stream_timeline.md)

## Examples

``` r
if (FALSE) { # \dontrun{
stream_timeline_public(1, file_name = "stream.json")
parse_stream("stream.json")
} # }
```
