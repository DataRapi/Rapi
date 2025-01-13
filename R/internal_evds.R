quick_check_evds <- function(key = "..") {
  domain <- "https://evds2.tcmb.gov.tr/service/evds"

  api_key_evds <- key
  if (is.null(key)) {
    api_key_evds <- get_api_key("evds")
  }

  url <- glue::glue("{domain}/categories/type=json")
  resp <- req_version_2_w_header(url, key = key)

  return(is_response(resp))
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
