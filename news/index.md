# Changelog

## rtoot 0.3.6.9000

- correct return value in
  [`post_toot()`](https://gesistsa.github.io/rtoot/reference/post_toot.md)
  documentation ([\#185](https://github.com/gesistsa/rtoot/issues/185))
- added simple error handling in
  [`post_toot()`](https://gesistsa.github.io/rtoot/reference/post_toot.md)
  ([\#185](https://github.com/gesistsa/rtoot/issues/185))
- use `withr` in tests
  ([\#180](https://github.com/gesistsa/rtoot/issues/180))
- switched to `httr2`
  ([\#169](https://github.com/gesistsa/rtoot/issues/169))
- use tryCatch for long running queries
  ([\#142](https://github.com/gesistsa/rtoot/issues/142))

## rtoot 0.3.6

CRAN release: 2025-07-24

- added better error messages when media upload fails
  ([\#160](https://github.com/gesistsa/rtoot/issues/160))
- fixed [\#172](https://github.com/gesistsa/rtoot/issues/172) added
  experimental feature of posting threads
  ([\#173](https://github.com/gesistsa/rtoot/issues/173)) by
  [@llrs](https://github.com/llrs)
- fixed deprecated vcr calls

## rtoot 0.3.5

CRAN release: 2024-10-30

- fixed [\#153](https://github.com/gesistsa/rtoot/issues/153) by
  allowing POSIXct as `max_id`, `min_id` and `since_id`
  ([\#154](https://github.com/gesistsa/rtoot/issues/154)) by
  [@Kudusch](https://github.com/Kudusch)
- fixed [\#158](https://github.com/gesistsa/rtoot/issues/158) for VSCode
  and similar editors which return TRUE for `rstudio::isAvailable()`
  ([\#159](https://github.com/gesistsa/rtoot/issues/159))

## rtoot 0.3.4

CRAN release: 2024-01-09

- added progress bar for long running queries
  ([\#141](https://github.com/gesistsa/rtoot/issues/141)) by
  [@chainsawriot](https://github.com/chainsawriot)
- added 429 check
  ([\#144](https://github.com/gesistsa/rtoot/issues/144))
- fixed [\#146](https://github.com/gesistsa/rtoot/issues/146) by adding
  a confirmation step for
  `auth_setup(browser = FALSE)`([\#147](https://github.com/gesistsa/rtoot/issues/147))
- fixed [\#149](https://github.com/gesistsa/rtoot/issues/149) by
  removing quotes around the inputted instance name though
  `auth_setup(instance = "")`
  ([\#150](https://github.com/gesistsa/rtoot/issues/150)) by
  [@thisisnic](https://github.com/thisisnic)

## rtoot 0.3.3

CRAN release: 2023-11-05

- added support for lists
  ([\#135](https://github.com/gesistsa/rtoot/issues/135),
  [\#136](https://github.com/gesistsa/rtoot/issues/136))
- fixed links after transfer on GitHub

## rtoot 0.3.2

CRAN release: 2023-06-29

- added
  [`post_status()`](https://gesistsa.github.io/rtoot/reference/post_status.md)
  to favourite/bookmark/reblog statuses
  ([\#134](https://github.com/gesistsa/rtoot/issues/134))
- fixed example in
  [`get_status()`](https://gesistsa.github.io/rtoot/reference/get_status.md)
  ([\#134](https://github.com/gesistsa/rtoot/issues/134))

## rtoot 0.3.1

CRAN release: 2023-06-05

- Added proper citation
  ([\#133](https://github.com/gesistsa/rtoot/issues/133))
- fixed `get_instance_rules` bug
  ([\#132](https://github.com/gesistsa/rtoot/issues/132))

## rtoot 0.3.0

CRAN release: 2023-01-09

- don’t throw an error when no rate limit is found
  ([\#95](https://github.com/gesistsa/rtoot/issues/95))
- switched API for
  [`get_fedi_instances()`](https://gesistsa.github.io/rtoot/reference/get_fedi_instances.md)
  ([\#122](https://github.com/gesistsa/rtoot/issues/122))
- added minimal endpoint
  ([\#123](https://github.com/gesistsa/rtoot/issues/123))
- fixed bugs ([\#113](https://github.com/gesistsa/rtoot/issues/113),
  [\#115](https://github.com/gesistsa/rtoot/issues/115))

## rtoot 0.2.0

CRAN release: 2022-11-30

- possible to set token via environment variable
  ([\#68](https://github.com/gesistsa/rtoot/issues/68))
- paginating results
  ([\#70](https://github.com/gesistsa/rtoot/issues/70))
- added ratelimit checking
  ([\#43](https://github.com/gesistsa/rtoot/issues/43))
- added pkgdown site
  ([\#79](https://github.com/gesistsa/rtoot/issues/79))
- added streaming functions `stream_*`
  ([\#84](https://github.com/gesistsa/rtoot/issues/84))
- added more instance endpoints
  ([\#34](https://github.com/gesistsa/rtoot/issues/34))

## rtoot 0.1.0

CRAN release: 2022-11-11

- Added a `NEWS.md` file to track changes to the package.
