
get_toke <- function(instance = "mastodon.social"){
  base_url <- paste0("https://",instance)
  dest <- "/api/v1/apps"
  tst <- httr::POST(paste0(base_url,dest),body=list(
    client_name="rtoot package",
    redirect_uris="urn:ietf:wg:oauth:2.0:oob",
    scopes="read write follow"))

  POST(paste0(base_url,"oauth/token"),body=list(
    client_id=content(tst)$client_id ,
    client_secret=content(tst)$client_secret,
    redirect_uri='urn:ietf:wg:oauth:2.0:oob',
    grant_type='client_credentials'
  )) -> tst1

}
