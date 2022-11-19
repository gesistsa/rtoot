library("vcr") # *Required* as vcr is set up on loading
invisible(
  vcr::vcr_configure(
         filter_sensitive_data = list("<<<MASTODON TOKEN>>>" = get_token_from_envvar("RTOOT_DEFAULT_TOKEN", check_stop = FALSE)$bearer),
         dir = vcr::vcr_test_path("fixtures")
       ))
vcr::check_cassette_names()


##skip_msg <- "System clipboard is not available - skipping test."
is_clipr_available <- clipr::clipr_available()
##message("Is clipr available?: ", is_clipr_available)
