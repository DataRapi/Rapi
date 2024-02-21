#' Creates an excel file from a data.frame or a list of data.frame or from
#' Rapi_GETPREP object.
#' @description
#' The excel() function creates an excel file according to the object given.
#' data.frame or List of data frame or Rapi_GETPREP object can be passed..
#' @param dfs object or list of data frame to write
#' @param file_name file name to save
#' @param folder folder to save file
#' @param .debug for internal use
#' @param env environment
#' @param ... for future versions
#' @return it returns object or list of data frame back
#' @export
#' @examples
#' \dontrun{
#' excel(data.frame(a = 1:3), file_name = "test1.xlsx", folder = ".")
#' }
excel <- function(
    dfs = null,
    file_name = null,
    folder = null,
    .debug = FALSE,
    env = rlang::caller_env(),
    ...) {
  obj <- excel_internal(
    dfs = dfs,
    file_name = file_name,
    folder = folder,
    .debug = .debug,
    env = env,
    ...
  )
  inv(obj)
}
check_rehber <- function(df = NULL) {
  rehber <- attr(df, "rehber")
  df2 <- df
  if (is.data.frame(rehber)) {
    df2 <- list(data = df, rehber = rehber)
  }
  df2
}

excel2 <- function(df, ...) {
  rehber <- attr(df, "rehber")
  if (is.data.frame(rehber)) {
    df2 <- list(data = df, rehber = rehber)
  }
  excel(df2, ...)
}

filter_list_df <- function(liste) {
  purrr::keep(liste, function(x) inherits(x, "data.frame"))
}
