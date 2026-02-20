# Post status update to user's Mastodon account

Be aware that excessive automated posting is frowned upon (or even
against the ToS) in many instances. Make sure to check the ToS of your
instance and be mindful when using this function.

## Usage

``` r
post_toot(
  status = "my first rtoot #rstats",
  media = NULL,
  alt_text = NULL,
  token = NULL,
  in_reply_to_id = NULL,
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

- media:

  character, path to media to add to post

- alt_text:

  character, a plain-text description of the media, for accessibility
  purposes.

- token:

  user bearer token (read from file by default)

- in_reply_to_id:

  character, ID of the status being replied to, if status is a reply

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

API response, invisibly. If the status was posted successfully, the
response will contain the posted status.

## Examples

``` r
if (FALSE) { # \dontrun{
# post a simple status
post_toot("my first rtoot #rstats")
# post a media file with alt text
post_toot("look at this pic", media = "path/to/image", alt_text = "describe image")
} # }
```
