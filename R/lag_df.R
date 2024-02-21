#' lag_df
#' @description
#' The `lag_df` function creates additional columns based on a list of column names
#' and lag sequences. This feature is beneficial for scenarios where you need
#' varying lag selections for certain columns, allowing flexibility in specifying
#' different lags for different columns or opting for no lag at all.
#' @param df A data.frame or tibble.
#' @param laglist A list of column names where each index corresponds to a column
#' name and the associated value is the lag sequence.
#' @return tibble
#' @export
#'
#' @examples
#' df <- data.frame(a = 1:15, b = 2:16)
#' tb <- lag_df(df, laglist = list(a = 1:5, b = 1:3))
lag_df <- function(df, laglist) {
  .Call(`_Rapi_lag_df2_c`, df, laglist)
}

as_tibblex <- function(df) {
  .Call(`_Rapi_as_tibblex`, df)
}
#' lag_df2
#' @description
#' The `lag_df2` function creates additional columns based on a list of column names
#' and lag sequences. This feature is beneficial for scenarios where you need
#' varying lag selections for certain columns, allowing flexibility in specifying
#' different lags for different columns or opting for no lag at all.
#' @param df A data.frame or tibble.
#' @param laglist A list of column names where each index corresponds to a column
#' name and the associated value is the lag sequence.
#' @return data.frame
#' @export
#'
#' @examples
#' df <- data.frame(a = 1:15, b = 2:16)
#' df2 <- lag_df2(df, laglist = list(a = 1:5, b = 1:3))
lag_df2 <- function(df, laglist) {
  .Call(`_Rapi_lag_df_c`, df, laglist)
}
