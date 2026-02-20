# Post a thread

Create a thread of your messages.

## Usage

``` r
post_thread(
  status = c("my first rtoot #rstats", "my first thread with rtoot"),
  token = NULL,
  sensitive = FALSE,
  spoiler_text = NULL,
  visibility = "public",
  scheduled_at = NULL,
  language = NULL,
  verbose = TRUE
)
```

## Arguments

- status:

  character, toot status. Must be 500 characters or less.

- token:

  user bearer token (read from file by default)

- sensitive:

  logical, mark status and attached media as sensitive?

- spoiler_text:

  character, text to be shown as a warning or subject before the actual
  content. Statuses are generally collapsed behind this field.

- visibility:

  character, Visibility of the posted status. One of public (default),
  unlisted, private, direct.

- scheduled_at:

  ISO 8601 Datetime at which to schedule a status. Must be at least 5
  minutes in the future.

- language:

  ISO 639 language code for this status.

- verbose:

  logical whether to display messages

## Value

A character vector with the ids of the toots posted.

## Examples

``` r
if (FALSE) { # \dontrun{
pt <- post_thread(visibility = "direct")
} # }
```
