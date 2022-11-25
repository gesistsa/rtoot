## code to prepare `empty` dataset goes here
empty <- list()

empty[["account"]] <- tibble::tibble(
  id = NA_character_,
  username = NA_character_,
  acct = NA_character_,
  created_at = NA_character_,
  display_name = NA_character_,
  locked = NA,
  bot = NA,
  discoverable = NA,
  group = NA,
  note = NA_character_,
  url = NA_character_,
  avatar = NA_character_,
  avatar_static = NA_character_,
  header = NA_character_,
  header_static = NA_character_,
  follower_count = NA_integer_,
  following_count = NA_integer_,
  statuses_count = NA_integer_,
  last_status_at = NA_character_,
  emojis = I(list(list())),
  fields = I(list(list()))
)

empty[["status"]] <- tibble::tibble(id = NA_character_, uri = NA_character_, created_at = NA_character_, content = NA_character_, visibility = NA_character_, sensitive = NA, spoiler_text = NA_character_, reblogs_count = 0, favourites_count = 0, replies_count = 0, url = NA_character_, in_reply_to_id = NA_character_, in_reply_to_account_id = NA_character_, language = NA_character_, text = NA_character_, application = I(list(list())), poll = I(list(list())), card = I(list(list())), account = I(list(list())), reblog = I(list(list())), media_attachments = I(list(list())), mentions = I(list(list())), tags = I(list(list())), emojis = I(list(list())), favourited = NA, reblogged = NA, muted = NA, bookmarked = NA, pinned = NA)

usethis::use_data(empty, overwrite = TRUE)
