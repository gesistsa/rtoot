# Perform actions on a status

Perform actions on a status

## Usage

``` r
post_status(id, action = "favourite", token = NULL, verbose = TRUE)
```

## Arguments

- id:

  character, status id to perform the action on

- action:

  character, one of "(un)favourite","(un)reblog","(un)bookmark"

- token:

  user bearer token (read from file by default)

- verbose:

  logical whether to display messages

## Value

no return value, called for site effects

## Examples

``` r
if (FALSE) { # \dontrun{
# favourite a status
post_status("xxxxxx", action = "favourite")
# unfavourite a status
post_status("xxxxxx", action = "unfavourite")
} # }
```
