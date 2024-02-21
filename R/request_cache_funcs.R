# **************** cache_name_format ****************************************cache_name_format**
cache_name_format_request <- function(prop_name) {
  return(paste("api_req", prop_name, sep = "_"))
}
# **************** .check_cache ****************************************.check_cache**
.check_cache <- function(prop_name) {
  check_cache(cache_name_format_request(prop_name))
}
# **************** .save_cache ****************************************.save_cache**
.save_cache <- function(prop_name, data) {
  save_cache(cache_name_format_request(prop_name), data)
}
# **************** .load_cache ****************************************.load_cache**
.load_cache <- function(prop_name) {
  load_cache(cache_name_format_request(prop_name))
}
