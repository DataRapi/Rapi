request_httr <- function(currentObj) {
  # fred
  prop_value <- get_prop_value_from_source_object(currentObj)
  gelen <- httr::RETRY(
    verb = "GET",
    url = currentObj$url,
    path = currentObj$observations_url,
    query = currentObj$series_fnc(prop_value),
    terminate_on = error_list()$nums,
    times = 2
  )
}
request_httr2 <- function(currentObj) {
  # evds
  Rapi_env$currentObj <- currentObj
  url <- createUrlForSeries(currentObj)
  request_httr2_helper_evds(url, currentObj$cache)
}
seriesCollapse <- function(liste) {
  names_ <- names(liste)
  url_parts <- c()
  for (name in names_) {
    value <- liste[[name]]
    yeni <- paste(name, value, sep = "=")
    url_parts <- append(yeni, url_parts)
  }
  vector_to_template_in(url_parts, collapse = "&")
}
vector_to_template_in <- function(v, collapse = "") {
  f <- function(item) {
    glue::glue("{item}")
  }
  s <- sapply(v, f)
  paste0(s, collapse = collapse)
}
get_prop_value_from_source_object <- function(currentObj) {
  if (!is.null(currentObj$seriesID)) {
    prop_value <- currentObj$seriesID
  } else {
    prop_value <- currentObj$datagroup
  }
  if (is.null(prop_value)) {
    stop("request_httr function requires seriesID or datagroup")
  }
  prop_value
}
# FRED ........................... create_url_for_series_fred
create_url_for_series_fred <- function(currentObj) {
  prop_value <- get_prop_value_from_source_object(currentObj)
  urlParts <- currentObj$series_fnc(prop_value)
  paste0(
    currentObj$url, currentObj$observations_url, "?",
    seriesCollapse(urlParts)
  )
}
check_series_ID_for_dots <- function(currentObj, urlParts) {
  .base <- toString(attr(urlParts$series, "base"))
  .source <- toString(attr(urlParts$series, "source"))
  if (!(is_(.base, "series") && is_(.source, "evds"))) {
    return(urlParts)
  }
  .f <- function(a) {
    gsub("_", ".", a, fixed = T)
  }
  urlParts$series <- .f(urlParts$series)
  urlParts
}
get_freq_number_evds <- function(freq) {
  liste <- list(
    day = 1,
    workday = 2,
    week = 3,
    bimonth = 4,
    month = 5,
    quarter = 6,
    sixmonth = 7,
    year = 8
  )
  toLower_local <- function(x) {
    if (is.null(x)) {
      return("null")
    }
    tolower(x)
  }
  freq_unify <- function(string) {
    .liste <- list(
      m = "month",
      y = "year",
      q = "quarter",
      w = "week",
      "null" = "day"
    ) # series will default to most freq possible so
    # null should be the most frequent
    u_freq <- .liste[[toLower_local(string)]]
    if (is.null(u_freq)) {
      u_freq <- toLower_local(string)
    }
    u_freq
  }
  ..f2 <- function() {
    assert(is_(freq_unify("week"), "week"))
    # freq_unify( toLower_local( currentObj$freq)  )
    liste[[freq_u]]
    assert(is_(get_freq_number_evds("week"), 3))
  }
  freq_u <- freq_unify(toLower_local(freq))
  freq_u <- liste[[freq_u]]
  freq_u
}
check_freq_only_evds_series <- function(currentObj, urlParts) {
  .base <- toString(attr(urlParts$series, "base"))
  .source <- toString(attr(urlParts$series, "source"))
  if (!(is_(.base, "series") && is_(.source, "evds"))) {
    return(urlParts)
  }
  # only for evds series ( not table ones )
  # convert freq option to number
  # urlParts
  urlParts$frequency <- get_freq_number_evds(currentObj$freq)

  # start_date
  .date <- currentObj$start_date

  urlParts$startDate <- date_to_str_1(.date)
  urlParts
}


createUrlForSeries <- function(currentObj) {
  if (currentObj$name == "fred") {
    return(create_url_for_series_fred(currentObj))
  }
  # https://evds2.tcmb.gov.tr/service/evds/datagroup=bie_pbtablo2&type=json&startDate=01-01-1960&endDate=01-02-2200&key=
  # or the other one

  prop_value <- get_prop_value_from_source_object(currentObj)
  urlParts <- currentObj$series_fnc(prop_value)
  # freq is not needed in table ones only series of evds
  urlParts <- check_freq_only_evds_series(currentObj, urlParts) # side effect start date will be checked


  Rapi_env$urlParts <- urlParts

  urlParts <- check_series_ID_for_dots(currentObj, urlParts) # replace '_' , '.'

  urlParts$key <- null
  paste0(
    currentObj$url,
    currentObj$observations_url,
    seriesCollapse(urlParts)
  )
}





req_version_1_no_header <- function(url) {
  # ..................... 1
  req <- try_or_default(
    {
      httr2::request(url)
    },
    .default = null
  )
  # ..................... 2
  resp <- try_or_default(
    {
      httr2::req_perform(req)
    },
    .default = null
  )
  return(inv(resp))
}

req_version_2_w_header <- function(url) {
  # currently only EVDS request uses this version due to header policy change
  # TODO generalize if new source being added
  api_key <- get_api_key("evds")

  req <- httr2::request(url)
  req <- req |> httr2::req_headers(key = api_key)

  # req |> httr2::req_dry_run()
    suppressWarnings({
        resp <- try_or_default(
            {
                req |> httr2::req_perform()
            },
            .default = null
        )

    })

  return(inv(resp))
}
# request_with_param <- function(url) {
#   api_key <- get_api_key("evds")
#   req <- httr2::request(url)
#   req <- req |> httr2::req_headers(Bearer = api_key)
#
#   req |> httr2::req_dry_run()
#   response <- req |> httr2::req_perform()
#
#   return(response)
# }

# ...................................................... request_httr2_helper
request_httr2_helper_evds <- function(url, cache = TRUE) {
  cache_name <- cache_name_format("request_httr2_helper_evds", url)
  check <- check_cache_comp(cache_name, cache)
  if (check) {
    return(load_cache(cache_name))
  }
  # check if vector
  check_url_for_request(url)
  Rapi_env$last_req_url <- url

  # resp <- req_version_1_no_header(url) # with no Param
  resp <- req_version_2_w_header(url) # with PARAM

  if (is_response(resp)) {
    save_cache(cache_name, resp)
  }
  inv(resp)
}

# ...................................................... request_httr2_helper
request_httr2_helper <- function(url, cache = TRUE) {
  cache_name <- cache_name_format("request_httr2_helper", url)
  check <- check_cache_comp(cache_name, cache)
  if (check) {
    return(load_cache(cache_name))
  }
  # check if vector
  check_url_for_request(url)
  Rapi_env$last_req_url <- url

  resp <- req_version_1_no_header(url)


  if (is_response(resp)) {
    save_cache(cache_name, resp)
  }
  inv(resp)
}
# ...................................................... check_proxy_set_2
check_proxy_set_2 <- function() {
  sonuc <- ifelse(nchar(Sys.getenv("https_proxy")) > 2, T, F)
  invisible(sonuc)
}
# ...................................................... check_proxy_setting
check_proxy_setting <- function(requires_proxy = T, die_for_test = F) {
  if (!requires_proxy) {
    return(invisible(T))
  }
  sonuc <- check_proxy_set_2()
  if (!sonuc || die_for_test) {
    message("
====================================\n\r
Proxy setting  should be checked!
====================================\n\r
             ")
    stop()
  }
  return(invisible(T))
}
requestNow <- function(currentObj) {
  check_proxy_setting(currentObj$requires_proxy)
  # NOTE request_httr VS request_httr2
  list_fncs <- list(
    evds = request_httr2,
    evds_datagroup = request_httr2,
    fred = request_httr
  )
  request_fnc <- list_fncs[[currentObj$name]]


  should_I_wait_for_request(currentObj$name)
  result <- request_fnc(currentObj)

  invisible(result)
}
check_url_for_request <- function(url) {
  if (is.null(url)) {
    g <- glue::glue
    message(g(
      "
    ...............................................
      call :    {str_call}
    ...............................................
      "
    ))
    stop()
  }
  if (length(url) > 1) {
    g <- glue::glue
    message(g(
      "
    ...............................................
      call :    {str_call}
    ...............................................
      "
    ))
    stop()
  }
}
