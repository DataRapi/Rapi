correct_if_vector <- function(template) {
  if (looks_like_template(template)) {
    return(template)
  }

  join(template, "\n")
}
get_lines_index <- function(template = template_test(), min_char_ID = 3) {
  template <- correct_if_vector(template)
  items <- stringr::str_split_1(template, "\n")
  x <- items[nchar(sp_trim(items)) >= min_char_ID]
  indexes <- sapply(x, FUN = remove_aciklama)
  comments <- sapply(x, FUN = get_comments)
  source_ <- sapply(x, FUN = get_comments_source)
  base_ <- sapply(x, FUN = guess_base_format)
  structure(indexes,
    comments = comments,
    source = source_,
    base = base_
  )
}
get_lines_as_df <- function(template = template_test(), min_char_ID = 3) {
  a <- get_lines_index(template = template, min_char_ID = min_char_ID)
  df <- data.frame(
    index = a,
    source = attr(a, "source"),
    base = attr(a, "base"),
    comments = attr(a, "comments")
  )
  tibble::as_tibble(df)
}
includes <- function(obj, item) {
  grepl(item, obj)
}
never_empty <- function(result, default = " ") {
  if (length(result) == 0) {
    result <- c(default)
  }
  unlist(result)
}
get_comments <- function(line = "ID #asdf#@fred#asdf") {
  comment <- unlist(stringr::str_split(line, "#"))
  result <- comment[-1]
  never_empty(result, " ")
}
get_comments_source <- function(line) {
  comments <- unlist(stringr::str_split(line, "#"))
  comments <- sp_trim(comments)
  if (any(includes(comments, "@fred"))) {
    return("fred")
  }
  if (any(includes(comments, "@evds"))) {
    return("evds")
  }
  guess_source_format(comments[[1]])
}
guess_base_format <- function(gosterge = "asdasd-asdads") {
  source_name <- guess_source_format(gosterge)
  if (is_(source_name, "evds")) {
    if (grepl("bie_", gosterge)) {
      return("table")
    }
    return("series")
  }
  if (is_(source_name, "fred")) {
    return("series")
  }
  return("unknown_format_unknown_source")
}
guess_source_format <- function(gosterge = "asdasd-asdads") {
  evds_m <- grepl("_", gosterge) || grepl(".", gosterge, fixed = T) || grepl("bie_", gosterge)
  fred_m <- evds_m == F # third source here
  if (evds_m) {
    return("evds")
  }
  if (fred_m) {
    return("fred")
  }
  return("no_source")
}
remove_aciklama <- function(x) {
  b <- unlist(stringr::str_split(x, "#"))[[1]]
  comment <- get_comments(x)
  result <-
    trimws(b,
      which = c("both", "left", "right"),
      whitespace = "[ \t\r\n]"
    )
  structure(result, comment = comment)
}
