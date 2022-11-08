library("vcr") # *Required* as vcr is set up on loading
invisible(
  vcr::vcr_configure(
         filter_sensitive_data = list("<<<MASTODON TOKEN>>>" = Sys.getenv('RTOOT_DEFAULT_TOKEN')),
         dir = vcr::vcr_test_path("fixtures")
       ))
vcr::check_cassette_names()
