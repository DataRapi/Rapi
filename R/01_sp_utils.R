
get_hash <- function(n = 50) {
  a <- do.call(paste0, replicate(3, sample(LETTERS, n, TRUE), FALSE))
  paste0(a, sprintf("%04d", sample(9999, n, TRUE)), sample(LETTERS, n, TRUE))
}
is_empty_df <- function(df) {
  is.data.frame(df) && (nrow(df) == 0)
}
dynamic_exists <- function(varName = "xxy") {
  exists(rlang::sym(aaa <- varName), envir = rlang::global_env())
}
as_numeric <- function(vec) {
  suppressWarnings(as.numeric(vec))
}
is_testing_ <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}
to_string <- function(item) {
  if (is.null(item)) {
    return("null")
  }
  if (is_Rapi_GETPREP(item)) {
    return(g("\n
==========================================================
         (Object) Rapi_GETPREP ('{x$index}')
==========================================================\n
                      "))
  }
  toString(item)
}
add_class <- function(item, class_names) {
  classes <- class(item)
  class(item) <- c(class_names, classes)
  class(item) <- unique(class(item))
  item
}
try_or_default <- function(.expr, env = rlang::caller_env(), .default = null) {
  res_val <- "NA_default"
  try(
    {
      res_val <- rlang::eval_tidy(.expr, env = env)
    },
    silent = T
  )
  if (is.character(res_val) && res_val == "NA_default") {
    return(.default)
  }
  return(res_val)
}
get_print_tibble <- function(x) {
  a <- utils::capture.output(print(x))
  paste0(a, collapse = "\n")
}

assign_ <- function(name, data) {
  # development related function
  # assign(name , data , envir = rlang::global_env())
}
hash_func <- function(v) {
  g <- paste0(v, collapse = "_")
  digest::digest(g)

}

g <- glue::glue

get_safe <- function(item, env = rlang::global_env(), default = F) {
  sonuc <- default
  try(silent = T, {
    sonuc <- get(item, envir = env)
  })
  sonuc
}
is_false_false <- function(smt) {
  isFALSE(smt)
}
is_ <- function(x, y) {
  identical(x, y)
}
all_false <- function(...) {
  sonuc <- any(...)
  return(inv(is_false_false(sonuc)))
}
is_bad <- function(item = NA) {
  if (is.character(item)) {
    return(length(item) == 0)
  }
  if (is.list(item) || (length(item) > 0 && !is.na(item) && !is_false_false(item))) {
    return(false)
  }
  is_false_false(item) || is.null(item) || is.na(item)
}
inv <- function(...) {
  invisible(...)
}

enumerate <- function(items = c("a", "b", "c")) {
  rlist::list.zip(
    index = seq(len(items)),
    value = items
  )
}
len <- function(what) {
  if ("data.frame" %in% class(what)) {
    return(nrow(what))
  }
  if (is.list(what)) {
    return(length(names(what)))
  }
  length(what)
}
assert <- function(...) {
  stopifnot(...)
}
gsubs <- function(patterns = c("aa", "bb"), replacements = c("", ""), string = "asdasdaabb", fixed = T) {
  ..f <- function() {
    replacements <- c("", " ")
    replacements2 <- c("")
    patterns <- c("o", "e")
    string <- "SomeString"
    assert(gsubs(patterns, replacements, string) == "Sm String")
    assert(gsubs(patterns, replacements2, string) == "SmString")
  }
  if (length(patterns) > 1 && length(replacements) == 1) {
    replacements <- rep(replacements, length(patterns))
  }
  for (item in enumerate(patterns)) {
    replacement <- replacements[[item$index]]
    if (is.character(replacement)) {
      string <- gsub(item$value, replacements[[item$index]], string)
    }
  }
  string
}
# ================================================================= join
join <- function(items, sep = ",") {
  paste0(items, collapse = sep)
}
sp_trim <- function(x) {
  comment <-
    trimws(x,
      which = c("both", "left", "right"),
      whitespace = "[ \t\r\n]"
    )
  comment
}
read <- function(file_name) {
  content <- read.delim2(file_name, header = FALSE)
  paste0(content$V1, collapse = "\n")
}
create_cache_name_from_list <- function(dots) {
  v <- unlist(dots)
  h <- hash_func(v)
}

success <- function(...) {
  args <- list(...)
  for (item in args) {
    .green(paste("\n", item))
  }
}
