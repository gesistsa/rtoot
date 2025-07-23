# rtoot 0.3.6

* added better error messages when media upload fails  (#160)
* fixed #172 added experimental feature of posting threads (#173) by @llrs
* fixed deprecated vcr calls

# rtoot 0.3.5

* fixed #153 by allowing POSIXct as `max_id`, `min_id` and `since_id` (#154) by @Kudusch
* fixed #158 for VSCode and similar editors which return TRUE for `rstudio::isAvailable()` (#159)

# rtoot 0.3.4

* added progress bar for long running queries (#141) by @chainsawriot
* added 429 check (#144)
* fixed #146 by adding a confirmation step for `auth_setup(browser = FALSE)`(#147)
* fixed #149 by removing quotes around the inputted instance name though `auth_setup(instance = "")` (#150) by @thisisnic

# rtoot 0.3.3

* added support for lists (#135, #136)
* fixed links after transfer on GitHub 

# rtoot 0.3.2

* added `post_status()` to favourite/bookmark/reblog statuses (#134)
* fixed example in `get_status()` (#134)

# rtoot 0.3.1

* Added proper citation (#133)
* fixed `get_instance_rules` bug (#132)

# rtoot 0.3.0

* don't throw an error when no rate limit is found (#95)
* switched API for `get_fedi_instances()` (#122)
* added minimal endpoint (#123)
* fixed bugs (#113, #115)

# rtoot 0.2.0

* possible to set token via environment variable (#68)
* paginating results (#70)
* added ratelimit checking (#43)
* added pkgdown site (#79)
* added streaming functions `stream_*` (#84)
* added more instance endpoints (#34)

# rtoot 0.1.0

* Added a `NEWS.md` file to track changes to the package.

