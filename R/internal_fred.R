quick_check_fred <- function(key = "..") {
  url <- "https://api.stlouisfed.org/fred/category/series?category_id=125&api_key=%s&file_type=json"
  url <- sprintf(url, key)

  gelen <- request_httr2_helper(url, cache = F)
  if (!is_response(gelen)) {
    return(false)
  }
  true
}
