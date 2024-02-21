check_data <- function(.data, dots_params) {
  if (!(is.data.frame(.data$evds_data) || !is.data.frame(.data$fred_data))) {
    call. <- ifelse(is.null(dots_params$call.), deparse(match.call()), dots_params$call.)
    msg <- "
      !error  :
    =====================================
      call : [{    call. }]
    =====================================
    "
    message(glue::glue(msg))
    # data
    # stop()
  }
}
