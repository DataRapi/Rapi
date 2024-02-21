#' Remove a column or columns from a data.frame.
#'
#' @param df Data.frame or tibble.
#' @param column_names Column name or column names as a character vector.
#' @param verbose Boolean, provides extra information when removing a column.
#' @usage remove_columns(df, column_names, verbose = FALSE)
#' @return Data.frame.
#' @export
#'
#' @examples
#' df <- remove_columns(cars, "speed")
#'
remove_columns <- function(df, column_names, verbose = FALSE) {
  for (column_name in column_names) {
    if (column_name %inn% df) {
      if (verbose) {
        .blue(" removing ...{column_name}\n\r")
      }
      try({
        df <- remove_column(df, column_name)
      })
    }
  }
  df
}


remove_column <- function(df, column_name) {
  if (!column_name %in% colnames(df)) {
    return(df)
  }

  valid_cols <- colnames(df)
  valid_cols <- valid_cols[valid_cols != column_name]

  df <- df[, valid_cols]

  if (length(valid_cols) == 1) {
    liste <- list()
    liste[[valid_cols]] <- df
    df <- as.data.frame(liste)
  }

  df
}


#' remove_na_safe
#' @description
#' This function removes rows from both ends of a data frame until it identifies
#' a row where all columns have non-NA values. Starting from the beginning, it
#' removes rows until it encounters a row with complete data at a specific row
#' index (e.g., row 5).
#' It then proceeds to remove rows from the end of the data frame, eliminating
#' any rows with at least one NA value in any column.
#' The process stops when it finds a row where all columns contain non-NA values,
#' and the resulting data frame is returned.
#'
#' @param df data.frame to remove na rows from the beginning and from the end
#' @param verbose give detailed info while removing NA values
#'
#' @usage remove_na_safe(df , verbose = FALSE )
#' @return data.frame returns data.frame after removing rows if all columns are NA
#' from the beginning and after
#' @export
#' @examples
#'
#' df <- data.frame(
#'   a = c(NA, 2:7, NA),
#'   b = c(NA, NA, 5, NA, 12, NA, 8, 9)
#' )
#' df2 <- remove_na_safe(df)
remove_na_safe <- function(df, verbose = FALSE) {
  df <- df_check_remove(df, verbose = verbose)
  invisible(df)
}
remove_any_na <- function(df) {
  df <- dplyr::filter(df, rowSums(is.na(df)) == 0)
}
first_row_that_ok <- function(df_, reverse = FALSE, except = null) {
  if (!is.null(except)) {
    df_ <- df_ %>% dplyr::select(-c(except))
  }
  numbers <- seq(from = 1, to = nrow(df_))
  if (reverse) {
    numbers <- seq(from = nrow(df_), to = 1)
  }
  for (num in numbers) {
    a <- df_[num:num, ]
    cond <- all(!is.na(unlist(as.vector(a))))
    if (cond) {
      # print( as.vector(a)  )
      return(num)
    }
  }
  return(NA)
}
looks_like_template <- function(x) {
  is.character(x) && length(x) == 1 && grepl("\n", x[[1]])
}
last_row_that_ok <- function(df_) {
  first_row_that_ok(df_, reverse = TRUE)
}
safe_remove_col <- function(df, colname) {
  if (!colname %in% colnames(df)) {
    return(df)
  }
  df %>% dplyr::select(-c(!!colname))
}
df_check_remove <- function(df, verbose = FALSE) {
  first_row <- first_row_that_ok(df)
  last_row <- last_row_that_ok(df)
  if (any(purrr::map_vec(c(first_row, last_row), is.na))) {
    return(df)
  }
  df2 <- df[first_row:last_row, ]
  n_ <- nrow(df)
  fark <- nrow(df) - nrow(df2)
  if (verbose) {
    .green(
      "
     first_row : {first_row }
     last_row : {last_row }
     {fark} rows removed ...
                  "
    )
  }
  return(df2)
}
# ..................................................   convert_df_numeric_helper
convert_df_numeric_helper <- function(df) {
  df <- remove_column(df, "Tarih")
  df <- remove_column(df, "YEARWEEK")
  if (!is.data.frame(df)) {
    return(df)
  }
  return(
    try_or_default(
      {
        df %>% dplyr::mutate_if(is.character, as.numeric)
      },
      .default = df
    )
  )
}
# ........................................................................ limit_ilk_yil
limit_start_date <- function(sonuc, start_date = default_start_date()) {
  if (!is.data.frame(sonuc) || is.null(start_date)) {
    return(sonuc)
  }

  if ("date" %in% colnames(sonuc)) {
    sonuc <- sonuc |> dplyr::filter(date >= lubridate::ymd(start_date))
  }

  sonuc
}
