# Introduction to rtoot

This vignette provides a quick tour of the package.

``` r
library("rtoot")
```

## Authenticate

First you should set up your own credentials (see also the vignette on
[authentication](https://gesistsa.github.io/rtoot/articles/auth.md))

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
within your own instance (e.g
[`get_timeline_home()`](https://gesistsa.github.io/rtoot/reference/get_timeline_home.md)),
others can access all instances but you need to specify the instance as
a parameter
(e.g. [`get_timeline_public()`](https://gesistsa.github.io/rtoot/reference/get_timeline_public.md)).

A list of active instances can be obtained with
[`get_fedi_instances()`](https://gesistsa.github.io/rtoot/reference/get_fedi_instances.md).
The results are sorted by number of users.

General information about an instance can be obtained with
[`get_instance_general()`](https://gesistsa.github.io/rtoot/reference/get_instance.md)

``` r
get_instance_general(instance = "mastodon.social")
```

[`get_instance_activity()`](https://gesistsa.github.io/rtoot/reference/get_instance.md)
shows the activity for the last three months and
[`get_instance_trends()`](https://gesistsa.github.io/rtoot/reference/get_instance.md)
the trending hashtags of the week.

``` r
get_instance_activity(instance = "mastodon.social")
get_instance_trends(instance = "mastodon.social")
```

## Get toots

To get the most recent toots of a specific instance use
[`get_timeline_public()`](https://gesistsa.github.io/rtoot/reference/get_timeline_public.md)

``` r
get_timeline_public(instance = "mastodon.social")
```

To get the most recent toots containing a specific hashtag use
[`get_timeline_hashtag()`](https://gesistsa.github.io/rtoot/reference/get_timeline_hashtag.md)

``` r
get_timeline_hashtag(hashtag = "rstats", instance = "mastodon.social")
```

The function
[`get_timeline_home()`](https://gesistsa.github.io/rtoot/reference/get_timeline_home.md)
allows you to get the most recent toots from your own timeline.

``` r
get_timeline_home()
```

## Get accounts

`rtoot` exposes several account level endpoints. Most require the
account id instead of the username as an input. There is, to our
knowledge, no straightforward way of obtaining the account id. With the
package you can get the id via
[`search_accounts()`](https://gesistsa.github.io/rtoot/reference/search_accounts.md).

``` r
search_accounts("schochastics")
```

*(Future versions will allow to use the username and user id
interchangeably)*

Using the id, you can get the followers and following users with
[`get_account_followers()`](https://gesistsa.github.io/rtoot/reference/get_account_followers.md)
and
[`get_account_following()`](https://gesistsa.github.io/rtoot/reference/get_account_following.md)
and statuses with
[`get_account_statuses()`](https://gesistsa.github.io/rtoot/reference/get_account_statuses.md).

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

*Be aware that excessive automated posting is frowned upon (or even
against the ToS) in many instances. Make sure to check the ToS of your
instance and be mindful when using this function.*

## Pagination

All relevant functions in the package support pagination of results if
the `limit` parameter is larger than the default page size (which is 40
in most cases). In this case, you may get more results than requested
since the pages are always fetched as a whole. If you for example
request 70 records, you will get 80 back, given that many records exist.
