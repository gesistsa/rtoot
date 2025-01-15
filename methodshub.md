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
timeline of a Mastodon instance, e.g. sciences.social.

``` r
library(rtoot)
get_timeline_public(instance = "sciences.social")
```

    # A tibble: 20 × 29
       id        uri   created_at          content visibility sensitive spoiler_text
       <chr>     <chr> <dttm>              <chr>   <chr>      <lgl>     <chr>       
     1 11383222… http… 2025-01-15 11:35:50 "<p>To… public     FALSE     ""          
     2 11383222… http… 2025-01-15 11:51:55 "<p>“O… public     FALSE     ""          
     3 11383222… http… 2025-01-15 11:51:47 "<p><a… public     FALSE     ""          
     4 11383222… http… 2025-01-15 11:51:38 "<p>de… public     FALSE     ""          
     5 11383222… http… 2025-01-15 11:34:33 "<p>In… public     FALSE     ""          
     6 11383222… http… 2025-01-15 11:51:20 "<p>On… public     FALSE     ""          
     7 11383222… http… 2025-01-15 11:51:32 "<p>To… public     FALSE     ""          
     8 11383222… http… 2025-01-15 11:51:29 "<p>Ge… public     FALSE     ""          
     9 11383222… http… 2025-01-15 11:36:25 "<p>Ma… public     FALSE     ""          
    10 11383222… http… 2025-01-15 06:14:00 "<p>Bi… public     FALSE     ""          
    11 11383222… http… 2025-01-15 11:51:16 "<p>De… public     FALSE     ""          
    12 11383222… http… 2025-01-15 11:51:20 "<p>Ju… public     FALSE     ""          
    13 11383222… http… 2025-01-15 05:52:00 "<p>Al… public     FALSE     ""          
    14 11383222… http… 2025-01-15 11:51:12 "<p>St… public     FALSE     ""          
    15 11383222… http… 2025-01-15 11:51:13 "<p>Sp… public     FALSE     ""          
    16 11383222… http… 2025-01-15 11:51:10 "<p>Hi… public     FALSE     ""          
    17 11383222… http… 2025-01-15 11:51:10 "<p>El… public     FALSE     ""          
    18 11383222… http… 2025-01-15 11:51:08 "<p><a… public     FALSE     ""          
    19 11383222… http… 2025-01-15 11:51:07 "<p>Ho… public     FALSE     ""          
    20 11383222… http… 2025-01-15 11:51:05 "<p>Th… public     FALSE     ""          
    # ℹ 22 more variables: reblogs_count <int>, favourites_count <int>,
    #   replies_count <int>, url <chr>, in_reply_to_id <lgl>,
    #   in_reply_to_account_id <lgl>, language <chr>, text <lgl>,
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
    <https://doi.org/10.1177/20501579231176678>

<!-- ## Acknowledgements -->

<!-- - Acknowledgements if any -->

<!-- ## Disclaimer -->

<!-- - Add any disclaimers, legal notices, or usage restrictions for the method, if necessary. -->
