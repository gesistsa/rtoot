
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtoot <img src="man/figures/logo.png" align="right"/>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/rtoot)](https://CRAN.R-project.org/package=rtoot)
[![R-CMD-check](https://github.com/schochastics/rtoot/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/schochastics/rtoot/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/schochastics/rtoot/branch/main/graph/badge.svg)](https://app.codecov.io/gh/schochastics/rtoot?branch=main)

<!-- badges: end -->

Interact with the [mastodon API](https://docs.joinmastodon.org/api/)
from R.  
Get started by reading `vignette("rtoot")`.

## Installation

You can install the development version of rtoot from GitHub:

``` r
devtools::install_github("schochastics/rtoot")
```

## Authenticate

First you should set up your own credentials (see also
`vignette("auth")`)

``` r
auth_setup()
```

The mastodon API allows different access levels. Setting up a token with
your own account grants you the most access.

## Instances

In contrast to twitter, mastodon is not a single instance, but a
federation of different servers. You sign up at a specific server (say
“mastodon.social”) but can still communicate with others from other
servers (say “fosstodon.org”). The existence of different instances
makes API calls more complex. For example, some calls can only be made
within your own instance (e.g `get_timeline_home()`), others can access
all instances but you need to specify the instance as a parameter
(e.g. `get_timeline_public()`).

A list of active instances can be obtained with `get_fedi_instances()`.
The results are sorted by number of users.

General information about an instance can be obtained with
`get_instance_general()`

``` r
get_instance_general(instance = "mastodon.social")
```

`get_instance_activity()` shows the activity for the last three months
and `get_instance_trends()` the trending hashtags of the week.

``` r
get_instance_activity(instance = "mastodon.social")
get_instance_trends(instance = "mastodon.social")
```

## Get toots

To get the most recent toots of a specific instance use
`get_timeline_public()`

``` r
get_timeline_public(instance = "mastodon.social")
```

To get the most recent toots containing a specific hashtag use
`get_timeline_hashtag()`

``` r
get_timeline_hashtag(hashtag = "rstats", instance = "mastodon.social")
```

The function `get_timeline_home()` allows you to get the most recent
toots from your own timeline.

``` r
get_timeline_home()
```

## Get accounts

`rtoot` exposes several account level endpoints. Most require the
account id instead of the username as an input. There is, to our
knowledge, no straightforward way of obtaining the account id. With the
package you can get the id via `search_accounts()`.

``` r
search_accounts("schochastics")
```

*(Future versions will allow to use the username and user id
interchangeably)*

Using the id, you can get the followers and following users with
`get_account_followers()` and `get_account_following()` and statuses
with `get_account_statuses()`.

``` r
id <- "109302436954721982"
get_account_followers(id)
get_account_following(id)
get_account_statuses(id)
```

## Posting statuses

You can post toots with:

``` r
post_toot(status = "my first rtoot #rstats")
```

It can also include media and alt_text.

``` r
post_toot(status = "my first rtoot #rstats", media="path/to/media", 
          alt_text = "description of media")
```

You can mark the toot as sensitive by setting `sensitive = TRUE` and add
a spoiler text with `spoiler_text`.

## Pagination

Most functions only return up to 40 results. The current version of
`rtoot` does not support pagination out of the box (but it is planned
for later). there is a workaround which can be found in the
[wiki](https://github.com/schochastics/rtoot/wiki/Pagination)

## Code of Conduct

Please note that the rtoot project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
