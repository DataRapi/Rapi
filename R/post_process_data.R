limit_years_of_data <- function(.data, dots_params) {
  if (is.null(.data)) {
    return(null)
  }

  .data <- .data %>% dplyr::filter(date >= dots_params$start_date)
  if (!is.null(dots_params$end_date)) {
    .data <- .data %>% dplyr::filter(date < dots_params$end_date)
  }
  .data
}
