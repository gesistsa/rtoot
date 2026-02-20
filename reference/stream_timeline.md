# Collect live streams of Mastodon data

Collect live streams of Mastodon data

## Usage

``` r
stream_timeline_public(
  timeout = 30,
  local = FALSE,
  file_name = NULL,
  append = TRUE,
  instance = NULL,
  token = NULL,
  anonymous = FALSE,
  verbose = TRUE
)

stream_timeline_hashtag(
  hashtag = "rstats",
  timeout = 30,
  local = FALSE,
  file_name = NULL,
  append = TRUE,
  instance = NULL,
  token = NULL,
  anonymous = FALSE,
  verbose = TRUE
)

stream_timeline_list(
  list_id,
  timeout = 30,
  file_name = NULL,
  append = TRUE,
  instance = NULL,
  token = NULL,
  anonymous = FALSE,
  verbose = TRUE
)
```

## Arguments

- timeout:

  Integer, Number of seconds to stream toots for. Stream indefinitely
  with timeout = Inf. The stream can be interrupted at any time, and
  file_name will still be a valid file.

- local:

  logical, Show only local statuses (either statuses from your instance
  or the one provided in `instance`)?

- file_name:

  character, name of file. If not specified, will write to a temporary
  file stream_toots\*.json.

- append:

  logical, if TRUE will append to the end of file_name; if FALSE, will
  overwrite.

- instance:

  character, the server name of the instance where the status is
  located. If `NULL`, the same instance used to obtain the token is
  used.

- token:

  user bearer token (read from file by default)

- anonymous:

  logical, should the API call be made anonymously? Defaults to TRUE but
  some instances might need authentication here

- verbose:

  logical whether to display messages

- hashtag:

  character, hashtag to stream

- list_id:

  character, id of list to stream

## Value

does not return anything. Statuses are written to file

## Details

- stream_timeline_public:

  stream all public statuses on any instance

- stream_timeline_hashtag:

  stream all statuses containing a specific hashtag

- stream_timeline_list:

  stream the statuses of a list

## Examples

``` r
if (FALSE) { # \dontrun{
# stream public timeline for 30 seconds
stream_timeline_public(timeout = 30, file_name = "public.json")
# stream timeline of mastodon.social  for 30 seconds
stream_timeline_public(
    timeout = 30, local = TRUE,
    instance = "mastodon.social", file_name = "social.json"
)

# stream hashtag timeline for 30 seconds
stream_timeline_hashtag("rstats", timeout = 30, file_name = "rstats_public.json")
# stream hashtag timeline of mastodon.social  for 30 seconds
stream_timeline_hashtag("rstats",
    timeout = 30, local = TRUE,
    instance = "fosstodon.org", file_name = "rstats_foss.json"
)
# json files can be parsed with parse_stream()
parse_stream("rstats_foss.json")
} # }
```
