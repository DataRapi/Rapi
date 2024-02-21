get_series_from_source <- function(seriesID = "TP.KREHACBS.A2",
                                   debug = T,
                                   source_ = "evds",
                                   cache = T,
                                   asvector = F) {
  ## request Main
  currentObj <- get_api_with_source(source_)
  currentObj$cache <- should_I_check_cache(cache)
  currentObj$seriesID <- seriesID

  should_I_wait_for_request(source_)
  gelen <- requestNow(currentObj)
  if (isFALSE(
    die_if_bad_response(gelen, currentObj)
  )
  ) {
    return(false)
  }
  utils::capture.output(df <- currentObj$responseFnc(gelen, currentObj))
  if (asvector) {
    v1 <- convertResponseVector_general(df, currentObj)
    return(v1)
  }
  df <- structure(df, "serie_code" = seriesID, "seriesID" = seriesID)
  colnames(df) <- c("date", seriesID)
  return(invisible(df))
}

get_series_from_source_ABS_evds_patch <-
  function(seriesID,
           start_date = default_start_date(),
           cache = F,
           freq = null) {
    source_ <- "evds"
    ## request Main
    currentObj <- get_api_with_source(source_)
    currentObj$source <- source_
    currentObj$cache <- should_I_check_cache(cache)
    currentObj$seriesID <- seriesID
    currentObj$start_date <- start_date
    # patch **********************
    currentObj$freq <- freq

    should_I_wait_for_request(source_)
    gelen <- requestNow(currentObj)
    if (isFALSE(
      die_if_bad_response(gelen, currentObj)
    )
    ) {
      return(false)
    }

    utils::capture.output(df <- currentObj$responseFnc(gelen, currentObj))
    df <- structure(df, "serie_code" = seriesID, "seriesID" = seriesID)
    colnames(df) <- c("date", seriesID)
    return(invisible(df))
  }
get_series_evds <- function(seriesID = "TP.KREHACBS.A3",
                            start_date = default_start_date(),
                            ...,
                            debug = T,
                            cache = T) {
  if (looks_like_template(seriesID)) {
    message("NOTIMPLEMENTED")
    message("get_series_evds")
    stop()
  } else {
    sonuc <- get_series_from_source(seriesID, debug, "evds", cache)
  }
  limit_start_date(sonuc, start_date)
}
get_series_fred <- function(seriesID = "UNRATE",
                            start_date = default_start_date(),
                            ...,
                            debug = T,
                            cache = T) {
  result <- get_series_from_source(seriesID, debug, "fred", cache)
  limit_start_date(result, start_date)
}
convert_result_list_to_data_frame_general <- function(result_list, v) {
  df <- combine_dfs_by_date2(result_list)
  df <- df %>% dplyr::arrange(tarih)
  colnames(df) <- v
  df
}
get_api_with_source <- function(source_ = "evds_datagroup") {
  api_list <- API_List()
  currentObj <- api_list[[source_]]
  die_if_not_api_key(currentObj)
  currentObj
}
