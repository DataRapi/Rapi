#' print.Rapi_GETPREP
#' Generic method for S3 Rapi_GETPREP object
#' @param x S3 Rapi_GETPREP object
#' @param ... further arguments passed to or from other methods.
#'
#' @return S3 Rapi_GETPREP object
#' @export
#'
#' @examples
#' \dontrun{
#'
#' obj <- get_series(template_test())
#' print(obj)
#' }
print.Rapi_GETPREP <- function(x, ...) {
  g <- glue::glue
  start_date <- to_string(x$start_date)
  end_date <- to_string(x$end_date)
  tb <- get_print_tibble(x$lines)
  tb2 <- ifelse(is.data.frame(x$data), get_print_tibble(x$data), "[no data]")
  str1 <- "obj$lines$data"
  str2 <- "obj$data"
  template <- "\n
======================================Rapi_GETPREP=======
  status      : {x$status }
  index       : {x$index  }
  start_date  : {start_date}
  end_date    : {end_date}
  status [{x$status }]

 lines$data
===================
 ! each line corresponds to a different set of func and data
    data can be reached as below
        --> { crayon::red( str1   )}
  {tb}
 data
===================
  (combined) data

    a combined data frame will be constructed
    combined data can be reached as
        --> { crayon::red( str2 ) }
  {tb2}

=========================================================\n
  "
  .blue_force(template)
  inv(x)
}
combine_df <- function(x, ...) {
  # a$lines$data
  df <- combine_dfs_by_date2(x$lines$data)
  df <- remove_columns(df, "YEARWEEK")
  df
}
combine_dfs_by_date2 <- function(liste) {
  combined <- NULL
  for (item in liste) {
    item2 <- item
    if (is.data.frame(item2)) {
      if (!is.data.frame(combined)) {
        combined <- item2
      } else {
        combined <- dplyr::right_join(combined, item2, by = "date")
      }
    }
  }
  tibble::as_tibble(combined)
}
# ............................................................. get_data_all
get_data_all <- function(x) {
  get_f <- function(fnc_str) {
    evds_table_fnc <- function(row) {
      get_evds_table_api(row$index,
        # for table requests of evds start_date not required
        cache = x$cache,
        na.remove = x$na.remove
      )
    }
    evds_series_fnc <- function(row) {
      # freq
      attr(row$index, "source") <- row$source
      attr(row$index, "base") <- row$base
      get_series_from_source_ABS_evds_patch(row$index,
        start_date = x$start_date,
        cache = x$cache,
        freq = x$freq
      )
    }
    fred_series_fnc <- function(row) {
      get_series_fred(row$index,
        start_date = x$start_date,
        cache = x$cache
      )
    }
    liste <- list(
      fred_series_fnc = fred_series_fnc,
      evds_table_fnc = evds_table_fnc,
      evds_series_fnc = evds_series_fnc
    )
    liste[[fnc_str]]
  }

  v_get_f <- Vectorize(get_f)
  y <- x$lines %>% dplyr::mutate(fnc = v_get_f(fnc_str))
  data. <- list()
  for (row in seq(nrow(y))) {
    fnc <- y$fnc[[row]]
    if (is.function(fnc)) {
      DATA <- "null"
      try({
        DATA <- fnc(y[row, ])
      })


      DATA <- post_process_data_main(DATA, x)

      if (is.null(DATA)) {
        data.[[row]] <- "null"
      } else {
        data.[[row]] <- DATA
      }
    } else {
      data.[[row]] <- "null"
    }
  }
  y$data <- data.
  y
}

post_process_data_main <- function(DATA, x) {
  try({
    DATA <- limit_years_of_data(DATA, x)
  })

  if (isTRUE(x$na.remove)) {
    try({
      DATA <- remove_na_safe(DATA)
    })
  }


  DATA
}
# ............................................................. run.Rapi_GETPREP
gets <- function(x, ...) {
  #
  #   Since API keys are required to request data from both sources present in this package, while testing
  #   only mock results will be provided to the user or to the testing machine or just a prepared object which
  #   could be examine which sources are figured out for the fiven IDs by user if the .example parameter is TRUE.
  #   Because otherwise it will break with requiring API keys for the source(s) user provided as index ID.
  #
  #

  x <- assign_data_funcs(x)
  x$lines <- get_data_all(x)
  x$status <- "completed"
  x$data <- combine_df(x)
  x
}
registerS3method("print", "Rapi_GETPREP", print.Rapi_GETPREP, envir = rlang::global_env())
