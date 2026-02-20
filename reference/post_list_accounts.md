# Add accounts to a list

Add accounts to a list

## Usage

``` r
post_list_accounts(id, account_ids, token = NULL, verbose = TRUE)
```

## Arguments

- id:

  character, id of the list

- account_ids:

  ids of accounts to add (this is not the username)

- token:

  user bearer token (read from file by default)

- verbose:

  logical whether to display messages

## Value

no return value, called for site effects

## Examples

``` r
if (FALSE) { # \dontrun{
# add some accounts to a list
post_list_create(id = "1234", account_ids = c(1001, 1002))
} # }
```
