library("vcr") # *Required* as vcr is set up on loading
invisible(
  vcr::vcr_configure(
    filter_sensitive_data = list(
      "<<<MASTODON TOKEN>>>" = get_token_from_envvar(
        "RTOOT_DEFAULT_TOKEN",
        check_stop = FALSE
      )$bearer,
      "<<<INSTANCES.SOCIAL TOKEN>>>" = Sys.getenv(
        "RTOOT_INSTANCES_SOCIAL_TOKEN"
      )
    ),
    dir = vcr::vcr_test_path("fixtures")
  )
)
vcr::check_cassette_names()
