#' inn
#' @description
#' Checks if the second parameter includes the first one as a value, a column name, or a name.
#'
#' @param x Character to check if it exists in a vector or list.
#' @param table List, data frame, or any vector.
#'
#' @return Logical value TRUE if it exists, FALSE if it does not.
#' @export
#'
#' @examples
#' .check <- inn("a", list(a = 1:5))
inn <- function(x, table) {
  if (is.data.frame(table)) {
    return(x %in% colnames(table))
  }
  if (is.list(table)) {
    return(x %in% names(table))
  }

  return(base::match(x, table, nomatch = 0L) > 0L)
}



#' %inn%
#' @description
#' Checks if the second parameter includes the first one as a value, a column name, or a name.
#'
#' @param x Character to check if it exists in a vector or list.
#' @param table List, data frame, or any vector.
#'
#' @return Logical value TRUE if it exists, FALSE if it does not.
#' @export
#'
#' @examples
#' .check <- "a" %inn% data.frame(a = 1:5)
"%inn%" <- function(x, table) {
  inn(x, table)
}
