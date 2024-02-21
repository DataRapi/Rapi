create_params_list <- function(dots) {
  dots$version <- packageVersion("Rapi")
  # get_current_package_vers()
  dots$cache_name <- create_cache_name_from_list(dots)
  dots
}

date_to_str_1 <- function(.date) {
  sprintf(
    "%s-%s-%s",
    lubridate::day(.date),
    lubridate::month(.date),
    lubridate::year(.date)
  )
}
