# rtoot - Collecting and Analyzing Mastodon Data


## Description

<!-- - Provide a brief and clear description of the method, its purpose, and what it aims to achieve. Add a link to a related paper from social science domain and show how your method can be applied to solve that research question.   -->

An implementation of calls designed to collect and organize Mastodon
data via its Application Program Interfaces (API), which can be found at
the following URL: <https://docs.joinmastodon.org/>.

## Keywords

<!-- EDITME -->

- Mastodon
- Decentralized Social Network
- Social Media Data

## Science Usecase(s)

<!-- - Include usecases from social sciences that would make this method applicable in a certain scenario.  -->
<!-- The use cases or research questions mentioned should arise from the latest social science literature cited in the description. -->

Although not using this package, the data from the Mastodon API has been
used in various social science publications on platform migration
(e.g. [La Cava et al. 2023](https://doi.org/10.1038/s41598-023-48200-7))
and online network formation (e.g. [La Cava, et
al. 2021](https://doi.org/10.1007/s41109-021-00392-5)).

## Repository structure

This repository follows [the standard structure of an R
package](https://cran.r-project.org/doc/FAQ/R-exts.html#Package-structure).

## Environment Setup

With R installed:

``` r
install.packages("rtoot")
```

<!-- ## Hardware Requirements (Optional) -->
<!-- - The hardware requirements may be needed in specific cases when a method is known to require more memory/compute power.  -->
<!-- - The method need to be executed on a specific architecture (GPUs, Hadoop cluster etc.) -->

## Input Data

<!-- - The input data has to be a Digital Behavioral Data (DBD) Dataset -->
<!-- - You can provide link to a public DBD dataset. GESIS DBD datasets (https://www.gesis.org/en/institute/digital-behavioral-data) -->

No applicable.

## Sample Input and Output Data

<!-- - Show how the input data looks like through few sample instances -->
<!-- - Providing a sample output on the sample input to help cross check  -->

As a data collection software, this tool does not have any “sample
input”.

The output from this software is a [standard
tibble](https://cran.r-project.org/package=tibble) of data collected
from the Mastodon API.

## How to Use

<!-- - Providing HowTos on the method for different types of usages -->
<!-- - Describe how the method should be used, including installation, configuration, and any specific instructions for users. -->

Please refer to the [“Introduction to
rtoot”](https://gesistsa.github.io/rtoot/articles/rtoot.html) for a
comprehensive introduction of the package.

In general, one should first conduct the authentication to obtain an
access token. This can be done with the provided function
`auth_setup()`. For more information, please refer to the documentation
on
[authentication](https://gesistsa.github.io/rtoot/articles/auth.html).

However, it is also possible to use some of functions with
authentication. For example, it is possible to obtain the public
timeline of a Mastodon instance, e.g. emacs.ch.

``` r
library(rtoot)
get_timeline_public(instance = "emacs.ch")
```

    # A tibble: 20 × 29
       id        uri   created_at          content visibility sensitive spoiler_text
       <chr>     <chr> <dttm>              <chr>   <chr>      <lgl>     <chr>       
     1 11264208… http… 2024-06-19 07:23:24 "<p>Wh… public     FALSE     ""          
     2 11264208… http… 2024-06-19 07:23:19 "<p>L'… public     FALSE     ""          
     3 11264208… http… 2024-06-19 07:23:05 "<p><a… public     FALSE     ""          
     4 11264208… http… 2024-06-19 07:23:04 "<p>Wo… public     FALSE     ""          
     5 11264208… http… 2024-06-19 07:22:59 "<p>Ja… public     FALSE     ""          
     6 11264208… http… 2024-06-19 07:22:54 "<p>Al… public     FALSE     ""          
     7 11264208… http… 2024-06-19 07:04:28 "<p>Ru… public     FALSE     ""          
     8 11264208… http… 2024-06-19 07:22:35 "<p>Re… public     FALSE     ""          
     9 11264208… http… 2024-06-19 07:22:27 "<p>🎶… public     FALSE     ""          
    10 11264208… http… 2024-06-19 07:22:23 "<p>Ne… public     FALSE     ""          
    11 11264208… http… 2024-06-19 07:22:19 "<p>I … public     FALSE     ""          
    12 11264207… http… 2024-06-19 07:22:11 "<p><a… public     FALSE     ""          
    13 11264207… http… 2024-06-19 07:22:08 "So, W… public     FALSE     ""          
    14 11264207… http… 2024-06-19 07:22:02 "<p>Gi… public     FALSE     ""          
    15 11264207… http… 2024-06-19 07:22:00 "<p>\"… public     FALSE     ""          
    16 11264207… http… 2024-06-19 07:21:58 "<p>Fe… public     FALSE     ""          
    17 11264207… http… 2024-06-19 07:21:48 "Wow i… public     FALSE     ""          
    18 11264207… http… 2024-06-19 07:21:49 "<p>Sy… public     FALSE     ""          
    19 11264207… http… 2024-06-19 07:21:29 "<a cl… public     FALSE     ""          
    20 11264207… http… 2024-06-19 07:21:45 "<p><a… public     FALSE     ""          
    # ℹ 22 more variables: reblogs_count <int>, favourites_count <int>,
    #   replies_count <int>, url <chr>, in_reply_to_id <chr>,
    #   in_reply_to_account_id <chr>, language <chr>, text <lgl>,
    #   application <I<list>>, poll <I<list>>, card <I<list>>, account <list>,
    #   reblog <I<list>>, media_attachments <I<list>>, mentions <I<list>>,
    #   tags <I<list>>, emojis <I<list>>, favourited <lgl>, reblogged <lgl>,
    #   muted <lgl>, bookmarked <lgl>, pinned <lgl>

Other functions, e.g. `get_timeline_hashtag()`, `get_account_statuses()`
require authentication.

## Contact Details

Maintainer: David Schoch <david@schochastics.net>

Issue Tracker: <https://github.com/gesistsa/rtoot/issues>

## Publication

1.  Schoch, D., & Chan, C. H. (2023). Software presentation: Rtoot:
    Collecting and analyzing Mastodon data. Mobile Media &
    Communication, 11(3), 575-578.
    https://doi.org/10.1177/20501579231176678

<!-- ## Acknowledgements -->
<!-- - Acknowledgements if any -->
<!-- ## Disclaimer -->
<!-- - Add any disclaimers, legal notices, or usage restrictions for the method, if necessary. -->
