# Perform actions on an account

Perform actions on an account

## Usage

``` r
post_user(id, action = "follow", comment = "", token = NULL, verbose = TRUE)
```

## Arguments

- id:

  character, user id to perform the action on

- action:

  character, one of "(un)follow","(un)block", "(un)mute",
  "(un)pin","note"

- comment:

  character (if action="note"), The comment to be set on that user.
  Provide an empty string or leave out this parameter to clear the
  currently set note.

- token:

  user bearer token (read from file by default)

- verbose:

  logical whether to display messages

## Value

no return value, called for site effects

## Examples

``` r
if (FALSE) { # \dontrun{
# follow a user
post_user("xxxxxx", action = "follow")
# unfollow a user
post_user("xxxxxx", action = "unfollow")
} # }
```
