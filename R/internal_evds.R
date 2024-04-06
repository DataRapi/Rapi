quick_check_evds <- function(key = "..") {
  url <- create_evds_url("subject", key = key)
  gelen <- request_httr2_helper_evds(url, cache = F)
  if (!is_response(gelen)) {
    return(false)
  }
  T
}
mock_data_evds <- function() {
  dates <- seq(from = lubridate::ymd("2010-1-1"), to = lubridate::ymd("2025-1-1"), by = "month")
  num <- 100
  tibble::as_tibble(data.frame(list(
    date = dates[1:num],
    a = 1:num,
    b = 2:(num + 1)
  )))
}
