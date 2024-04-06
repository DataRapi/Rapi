# ................................................... add_errors_list_evds
add_errors_list_evds <- function(table_name) {
  message_debug(table_name)
}
get_name_verbose_option <- function() {
  "Rapi_VERBOSE"
}
set_option_verbose <- function() {
  options("Rapi_VERBOSE" = T)
  inv(character())
}
debug_message <- function(...) {
  .opt <- getOption(get_name_verbose_option())
  if (is.null(.opt) || is_false_false(.opt)) {
    return(inv(character()))
  }
  message(...)
}

# ............................................................. get_evds_table_api
get_evds_table_api <- function(table_name = "bie_altingr",
                               cache = F,
                               na.remove = F) {
  df <- try_or_default({
    get_evds_table_api_helper(table_name, cache)
  })
  if (is_bad(df) || is_empty_df(df)) {
    msg <- g("{ table_name} - Not DF ")
    add_errors_list_evds(msg)
    debug_message(msg)
    return(null)
  }
  if (is.data.frame(df) && !nrow(df)) {
    add_errors_list_evds(g("{ table_name} - nrow : 0 "))
    return(null)
  }
  df <- try_this_or(df, evds_date_ops, table_name)

  df <- try_this_or(df, convert_df_numeric_helper)
  df <- try_this_or(df, remove_column, "YEARWEEK")
  df <- try_this_or(df, remove_column, "UNIXTIME")
  rehber <- get_evds_table_info_api(table_name)
  if (is_false_false(rehber)) {
    rehber <- NULL
  }
  df <- try_this_or(df, remove_na_safe)
  df <- structure(df, rehber = rehber)
  return(df)
}
# get_data_evds<-function(table_name = "bie_altingr" ,
#                         start_date =default_start_date()  ,
#                         cache = T ){
#   get_evds_table_api( table_name = table_name ,
#                       start_date = start_date ,
#                       cache  = cache  )
# }
# ............................................................. get_evds_table_api_helper
get_evds_table_api_helper <- function(table_name = "bie_altingr", cache = F) {
  ..f <- function() {
    table_name <- "bie_altingr"
    cache <- F
  }
  currentObj <- get_api_with_source("evds_datagroup")
  currentObj$cache <- cache
  cache_name <- cache_name_format(get_evds_table_api, paste(table_name, sep = "_"))
  if (cache && check_cache(cache_name)) {
    return(load_cache(cache_name))
  }
  currentObj$datagroup <- table_name
  should_I_wait_for_request("evds")
  gelen <- requestNow(currentObj)
  if (is_false_false(die_if_bad_response(gelen, currentObj))) {
    return(false)
  }
  contentList <- gelen %>% httr2::resp_body_json()
  suppressWarnings(
    df <- convert_list_df_evds2(contentList$items)
  )
  if (is.data.frame(df)) {
    save_cache(cache_name, df)
  }
  df
}
# ............................................................. get_evds_table_info_api
get_evds_table_info_api <- function(table_name = "bie_altingr", cache = T) {
  url <- create_evds_url("info_api",
    table_name = table_name
  )
  gelen <- request_httr2_helper_evds(url, cache)
  if (!is_response(gelen)) {
    return(false)
  }
  gelen %>%
    httr2::resp_body_json() %>%
    convert_list_df_evds2()
}
# ............................................................. try_convert_date
try_convert_date <- function(x = "1950-1") {
  failed <- T
  try({
    x <- try_convert_date_helper(x)
    failed <- F
  })
  if (failed) {
    assign_("dbg_try_convert_date_failed", x)
  }
  x
}
try_convert_date_helper <- function(x = "1950-1") {
  a <- stringr::str_split_1(x, "-")
  if (length(a) < 2) {
    return(x)
  }
  year <- as.numeric(a[[1]])
  month <- as.numeric(a[[2]])
  res <- as.Date(ISOdate(
    year = year,
    month = month,
    day = 1
  ))
  res
}
vec_try_convert_date <- Vectorize(try_convert_date)
evds_weekly_date_patch <- function(df) {
  if (!evds_data_looks_weekly(df)) {
    return(df)
  }
  v <- unlist(df$Tarih)
  df$date <- lubridate::dmy(v)
  df
}
evds_data_looks_weekly <- function(df) {
  "YEARWEEK" %in% colnames(df)
}
evds_date_ops <- function(df, table_name) {
  v <- unlist(df$Tarih)
  v1 <- purrr::map(v, try_convert_date)
  df$date <- df$Tarih
  rehber <- get_evds_table_info_api(table_name)
  frekans <- rehber$FREQUENCY_STR[[1]]
  ucaylik_f <- function(x) {
    # x : 2023 - Q2
    v <- stringr::str_split_1(x, "-")
    year <- as.numeric(v[[1]])
    month <- as.numeric(gsub("Q", "", v[[2]]))
    lubridate::make_date(year, month, 1)
  }
  if (grepl(" AYL", frekans)) { # is_(frekans , "UC AYLIK" ) utf-8 problem
    df$date <- purrr::map_vec(df$Tarih, function(x) ucaylik_f(x))
    df %>% dplyr::select(date, everything())
    df
  } else {
    if (evds_data_looks_weekly(df)) {
      df <- evds_weekly_date_patch(df)
    } else {
      try({
        df$date <- v1 |> do.call(what = c)
      })
    }
  }
  df <- df |> dplyr::select(date, everything(), Tarih)
  return(df)
}
#
try_this_or <- function(df, func, ...) {
  gelenler <- list(...)
  df2 <- df
  try({
    if (!length(gelenler)) {
      df2 <- func(df)
    } else {
      df2 <- func(df, ...)
    }
  })
  return(df2)
}
test_try_this_or <- function() {
  a1_f <- function(a, b) {
    a + b
  }
  a2_f <- function(a, b, c) {
    a + b + c
  }
  try_this_or(10, a2_f, b = 18, 109)
  try_this_or(10, a2_f, b = 18, 109, 50)
  try_this_or(10, a1_f, 5)
}
