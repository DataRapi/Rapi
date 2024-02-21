getLineEvdsResponse <- function(item) {
  names_ <- names(item)
  if ("YEARWEEK" %in% names_) {
    return(getLineEvdsResponse_patch_week(item))
  }
  tarih <- item$Tarih
  value <- item[[names_[[2]]]]
  unix_time <- item[["UNIXTIME"]]
  unix_time <- unix_time$`$numberLong`
  list(date = unix_time, value = value)
}
getLineEvdsResponse_patch_week <- function(item) {
  assign_("d_item", item)
  # $Tarih
  # [1] "06-01-1950"
  #
  # $YEARWEEK
  # [1] "1950-1"
  #
  # $`TP_AB_N02-1`
  # [1] "ND"
  #
  # $UNIXTIME
  # $UNIXTIME$`$numberLong`
  # [1] "-630723600"
  #
  #
  # $TP_AB_N02
  # NULL
  names_ <- names(item)
  tarih <- item$Tarih
  value <- item[[names_[[3]]]]
  unix_time <- item[["UNIXTIME"]]
  unix_time <- unix_time$`$numberLong`
  list(date = unix_time, value = value)
}
getLineEvdsResponse2 <- function(item) {
  names_ <- names(item)
  new_list <- list()
  for (name in names_) {
    value <- item[[name]]
    if (is.list(value) || is.null(value) || is.na(value)) {
      new_list[[name]] <- NA
    } else {
      new_list[[name]] <- value
    }
  }
  new_list
}
getLineEvdsResponse3 <- function(item) {
  # item_name = "item"
  # if( !dynamic_exists( item_name)){
  #   assign( "item" ,item, envir = .GlobalEnv )
  # }
  # snames<- names_[ names_[c("Tarih" , "UNIXTIME")]  ]
  names_ <- names(item)
  yliste <- list()
  for (name in names_) {
    value <- item[[name]]
    if (is.list(value) || is.null(value) || is.na(value)) {
      # assign_( paste0("dbg_" , name  ) , value  )
      yliste[[name]] <- NA
    } else {
      yliste[[name]] <- value
    }
  }
  yliste
  # as.data.frame( yliste)
  # tarih = item$Tarih
  #
  # value <- item[[names_[[2]]]]
  #
  # value
  #
  # unix_time  <- item[[ "UNIXTIME" ]]
  #
  # unix_time <- unix_time$`$numberLong`
  #
  #
  #
  # list( date = unix_time , value = value   )
}
#
convert_list_df_evds <- function(items, strategy = getLineEvdsResponse) {
  assign_("d_items", items)

  lines_ <- null

  make_df_local <- function(line) {
    line$value <- line$value %||% NA

    as.data.frame(line)
  }

  for (item in items) {
    line <- strategy(item) # CHECK  2
    if (is.null(lines_)) {
      lines_ <- make_df_local(line)
    } else {
      try({
        line <- make_df_local(line)

        lines_ <- rbind(lines_, line)
      })
    }
  }
  tb <- tibble::as_tibble(lines_)
  tb$date <- makeDate(tb$date)
  tb$value <- as_numeric(tb$value)
  serie_code <- names(items)[[2]]
  tb <- structure(tb, serie_code = serie_code)
  tb
}
convert_list_df_evds_patch_week <- function(items, strategy = getLineEvdsResponse) {
  lines_ <- null
  for (item in items) {
    line <- strategy(item) # CHECK  2
    if (is.null(lines_)) {
      lines_ <- as.data.frame(line)
    } else {
      line <- as.data.frame(line)
      try({
        lines_ <- rbind(lines_, line)
      })
    }
  }
  tb <- tibble::as_tibble(lines_)
  tb$date <- makeDate(tb$date)
  tb$value <- as_numeric(tb$value)
  serie_code <- names(items)[[2]]
  tb <- structure(tb, serie_code = serie_code)
  tb
}
convert_list_df_evds_OLD <- function(items) {
  lines_ <- null
  for (item in items) {
    line <- getLineEvdsResponse(item) # CHECK  2
    if (is.null(lines_)) {
      lines_ <- as.data.frame(line)
    } else {
      line <- as.data.frame(line)
      try({
        lines_ <- rbind(lines_, line)
      })
    }
  }
  tb <- tibble::as_tibble(lines_)
  tb$date <- makeDate(tb$date)
  tb$value <- as_numeric(tb$value)
  serie_code <- names(items)[[2]]
  tb <- structure(tb, serie_code = serie_code)
  tb
}
makeDate <- function(date_str_vector_unixtime) {
  suppressWarnings({
    dt <- as_numeric(date_str_vector_unixtime)
    dt <- dt + 3 * 60 * 60
    x <- lubridate::as_datetime(dt)
    as.Date(x)
  })
}
