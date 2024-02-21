die_if_not_api_key <- function(api_object, force = F) {
  fnc <- api_object$check_api_key_fnc
  api_key_name <- api_object$api_key_name
  if (!fnc() |
    force == T) {
    die_if_not_api_key_helper(api_key_name)
  }
}
die_if_not_api_key_helper <- function(api_key_name = "xx") {
  msg <- glue::glue("{api_key_name} not found")
  message(msg)
  stop()
}
is_response <- function(gelen) {
  "httr2_response" %in% class(gelen) ||
    "httr_response" %in% class(gelen) ||
    "response" %in% class(gelen)
}
die_if_bad_response <- function(response, currentObj) {
  if (is_response(response) && response$status_code == 200) {
    return(invisible(TRUE))
  }
  if (!is_response(response)) {
    return(false)
  }
  die_if_bad_response_helper(response$status_code)
}
die_if_bad_response_helper <- function(status_code = 500) {
  problem <- error_means(status_code)
  message(problem)
  stop()
}
