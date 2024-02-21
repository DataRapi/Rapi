# ............................................... check_last_requested_from_source
check_last_requested_from_source <- function(.source = "evds") {
  last_time <- Rapi_env$last_requests


  value <- ifelse(.source %in% names(last_time),
    last_time[[.source]],
    get_yesterday()
  )
  value
}
# ............................................... save_last_requested_time
save_last_requested_time <- function(.source = "evds") {
  last_time <- check_last_requested_from_source(.source)
  if (is.null(last_time)) {
    last_time <- list(
      evds = Sys.time(),
      fred = Sys.time()
    )
  } else {
    last_time[[.source]] <- Sys.time()
  }

  Rapi_env$last_requests <- last_time

  inv(T)
}
# ...................................................................... get_now
get_now <- function(num = 0) {
  time <- Sys.time()
  hrs <- lubridate::hours(num)
  mod_time <- time - hrs
  mod_time
}
# ...................................................................... get_yesterday
get_yesterday <- function() {
  get_now(24)
}
# ...................................................................... time_is_ok
time_is_ok <- function(last_requested_time = get_yesterday(), seconds = 1) {
  now_ <- get_now()
  diff. <- now_ - last_requested_time # days
  diff_seconds <- (diff. * 24 * 60) # *60/60
  diff_seconds > seconds
}
# ...................................................................... should_I_wait_for_request
should_I_wait_for_request <- function(source_name = "evds", seconds = 1, .verbose = check_verbose_option()) {
  last_request_time <- check_last_requested_from_source(source_name)
  last_request_time <- as.POSIXct(last_request_time, origin = "1970-01-01")
  if (time_is_ok(last_request_time, seconds)) {
    save_last_requested_time(source_name)
    return(inv(F))
  }

  if (.verbose) {
    msg <- "pausing before a new request."
    .blue_force("->[{source_name}]: {msg}\n\r")
  }

  Sys.sleep(seconds)
  save_last_requested_time(source_name)
  return(inv(T))
}
# ...................................................................... test_should_I_wait_for_request
test_should_I_wait_for_request <- function(.verbose = T) {
  should_I_wait_for_request("evds", 3, .verbose) == T
  should_I_wait_for_request("evds", 3, .verbose) == T
  should_I_wait_for_request("evds", 4, .verbose) == F
  should_I_wait_for_request("evds", 2, .verbose) == T
  should_I_wait_for_request("fred", 5, .verbose) == F
  assert(
    should_I_wait_for_request("fred", 5, .verbose) == T
  )
  .green("done")
}
