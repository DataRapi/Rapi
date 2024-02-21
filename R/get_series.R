is_Rapi_GETPREP <- function(x) {
  inherits(x, "Rapi_GETPREP")
}

choose_fnc_for_source <- function(source = "evds", base = "series") {
  fnc_str <- "null"

  if (source == "evds" & base == "series") {
    fnc_str <- "evds_series_fnc"
  }
  if (source == "evds" & base == "table") {
    fnc_str <- "evds_table_fnc"
  }
  if (source == "fred") {
    fnc_str <- "fred_series_fnc"
  }
  fnc_str
}

vec_choose_fnc_for_source <- Vectorize(choose_fnc_for_source)

assign_data_funcs <- function(dots_params) {
  df <- dots_params$lines %>% dplyr::mutate(fnc_str = "null")
  df <- df %>% dplyr::mutate(fnc_str = vec_choose_fnc_for_source(source, base))
  dots_params$lines <- df
  dots_params
}


default_start_date <- function() {
  lubridate::ymd("2000/01/01")
}


default_end_date <- function() {
  lubridate::ymd("2100/01/01")
}


check_verbose_if_diff_change <- function(verbose = TRUE) {
  if (is.null(verbose)) {
    return()
  }
  current_verbose <- check_verbose_option()
  if (verbose != current_verbose) {
    if (verbose) {
      verbose_on()
    } else {
      verbose_off()
    }
  }
}
get_series_prepare <- function(index = null,
                               start_date = default_start_date(),
                               end_date = default_end_date(),
                               freq = null,
                               cache = FALSE,
                               na.remove = TRUE,
                               verbose = NULL,
                               ...,
                               source = c("multi", "evds", "fred"),
                               base = c("multi", "series", "table")) {
  if (is.null(index)) {
    # index <-   template_test()
    msg <- "
    index should be given to request data from sources.
    see README file or type `?get_series` for documentation and examples.
    "
    stop(msg, call. = F)
  }
  # check if change necessary
  check_verbose_if_diff_change(verbose)


  lines <- get_lines_as_df(index)
  lines$freq <- rep(to_string(freq), nrow(lines))
  call. <- deparse(match.call())
  dots_params <- create_params_list(c(as.list(environment()), list(...)))
  dots_params$status <- "ready_to_run"
  dots_params <- add_class(dots_params, "Rapi_GETPREP")
  dots_params
}
