#' Requests data from multiple data sources.
#'
#' The `get_series()` function retrieves data from various sources, including the EDDS API and FRED API at this version.
#' When multiple indexes are provided as a character vector or string template, the function individually
#' requests each item from the corresponding sources, discerning the source from the item's format.
#' The function combines data frames when there are common frequencies and returns both a combined data frame and
#' individual data frames for each requested item.
#'
#' @param index A character vector or string representing the index to be retrieved.
#' @param start_date Limits the start date of the data.
#' @param end_date Limits the end date of the data.
#' @param freq Frequency of the data (rarely needed).
#' @param cache If FALSE, a new request will be made; if TRUE, cached data will be used.
#' @param na.remove If TRUE, NA values are removed only if all columns are NA.
#' @param verbose If TRUE, prints information during the process; if FALSE, silently does its job.
#' default is NULL which implies applying default verbose option. If this function is called with
#' a TRUE or FALSE value it changes global verbose option for `Rapi` package.
#' If verbose option is FALSE it gives a warning only if something goes wrong.
#' @param ... Additional parameters for future versions.
#' @param debug Debug option for development.
#' @param source Source such as "evds" or "fred" for internal use at this version.
#' @param base Table or series on the source for internal use at this version.
#' @return An S3 object, Rapi_GETPREP, which has generic functions such as print and excel.
#' The `print` generic provides hints to the user on how to use requested data,
#' such as creating output with the `excel` function or examining requested data in the global environment.
#'
#' @export
#' @examples
#' \dontrun{
#' o <- get_series(template_test())
#' excel(o)
#' object <- get_series("UNRATE", start_date = "2000/01/01", na.remove = TRUE)
#' excel(object)
#' }
get_series <- function(index = NULL,
                       start_date = default_start_date(),
                       end_date = default_end_date(),
                       freq = NULL,
                       cache = FALSE,
                       na.remove = TRUE,
                       verbose = NULL,
                       ...,
                       source = c("multi", "evds", "fred"), # for internal use
                       base = c("multi", "series", "table"), # for internal use
                       debug = FALSE) {
  check_users_choice_if_cache(cache)

  obj <- get_series_prepare(
    index      = index,
    source     = source,
    base       = base,
    start_date = start_date,
    end_date   = end_date,
    freq       = freq,
    cache      = cache,
    na.remove  = na.remove,
    verbose    = verbose
  )

  if (debug) {
    return(obj)
  }
  obj <- gets(obj)
  obj
}
