test_that("defensive", {
  fake_client <- list()
  class(fake_client) <- "rtoot_cilent"
  expect_error(create_token(iris), "client is not an object of type rtoot_client")
  expect_error(create_token(fake_client, type = "elon"), "should be one of")
})

test_that("test for #149", {
    expect_equal(process_instance("\"fosstodon.org\""), "fosstodon.org")
    expect_equal(process_instance("\'fosstodon.org\'"), "fosstodon.org")
    expect_equal(process_instance("\'\'fosstodon.org\'\'"), "fosstodon.org")
    expect_equal(process_instance("fosstodon.org"), "fosstodon.org")
    expect_equal(process_instance("fosst\"odon.org"), "fosst\"odon.org")
})
