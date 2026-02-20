# Create a list

Create a list

## Usage

``` r
post_list_create(title, replies_policy = "list", token = NULL, verbose = TRUE)
```

## Arguments

- title:

  character, The title of the list to be created

- replies_policy:

  character, One of "followed", "list", or "none". Defaults to "list".

- token:

  user bearer token (read from file by default)

- verbose:

  logical whether to display messages

## Value

no return value, called for site effects

## Examples

``` r
if (FALSE) { # \dontrun{
# create a list
post_list_create(title = "test")
} # }
```
