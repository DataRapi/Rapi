response_fnc_fred <- function(gelen, currentObj) {
  parsed <- jsonlite::fromJSON(httr::content(gelen, "text"))
  df <- parsed$observations
  df <- df %>% dplyr::select(c("date", "value"))
  df$date <- lubridate::ymd(df$date)
  df$value <- as_numeric(df$value)
  result <- tibble::as_tibble(df)
  structure(result, series_code = currentObj$seriesID)
}
response_fnc_evds <- function(gelen, currentObj) {
  contentList <- gelen %>% httr2::resp_body_json()
  convert_list_df_evds(contentList$items)
}
convert_list_df_general <- function(response_list) {
  lines_ <- null
  for (item in response_list) {
    line <- item
    if (is.null(lines_)) {
      lines_ <- as.data.frame(line)
    } else {
      try({
        lines_ <- rbind_safe(lines_, as.data.frame(line))
      })
    }
  }
  tibble::as_tibble(lines_)
}
rbind_safe <- function(df1, df2) {
  cols_diff <- setdiff(colnames(df1), colnames(df2))
  cols_diff2 <- setdiff(colnames(df2), colnames(df1))
  cols_diff <- append(cols_diff, cols_diff2)
  if (length(cols_diff) == 0) {
    return(
      rbind(df1, df2)
    )
  }
  for (col in cols_diff) {
    df1 <- fill_na_df(df1, col)
    df2 <- fill_na_df(df2, col)
  }
  df3 <- rbind(df1, df2)
}
cbind_safe <- function(df1, df2) {
  if (nrow(df1) == nrow(df2)) {
  } else {
    if (nrow(df1) > nrow(df2)) {
      fark <- nrow(df1) - nrow(df2)
      df2 <- append(df2[[1]], rep(NA, fark))
    } else {
      fark <- nrow(df2) - nrow(df1)
      df1 <- append(df1[[1]], rep(NA, fark))
    }
  }
  cbind(df1, df2)
}
fill_na_df <- function(df, colname) {
  if (colname %in% colnames(df)) {
    return(df)
  }
  num <- nrow(df)
  if (is.numeric(num)) {
    df[[colname]] <- rep(NA, times = num)
  }
  df
}
convertResponseVector_evds <- function(tb) {
  if (is_false_false(tb)) {
    return(false)
  }
  structure(tb$value, dates = tb$date, serie_code = attr(tb, "serie_code"))
}
convertResponseVector_fred <- function(tb) {
  structure(tb$value,
    dates = tb$date,
    serie_code = attr(tb, "series_code")
  )
}
convertResponseVector_general <- function(df, currentObject) {
  liste <- list(
    evds = convertResponseVector_evds,
    fred = convertResponseVector_fred
  )
  fnc <- liste[[currentObject$name]]
  if (!is.function(fnc)) {
    return(null)
  }
  fnc(df)
}
