################################################################################
#
#                                                            cache
#
################################################################################
SYMB_CACHE_FOUND <- "[cache was found]"
SYMB_CACHE_SAVED <- "[cache was saved]"
SYMB_CACHE_LOAD <- "[cache was loaded]"
should_I_check_cache <- function(cache = TRUE) {
  return((exists("GlobalCacheOption",
    envir = rlang::global_env()
  ) && get("GlobalCacheOption") == T) && cache)
}
na_if_null <- function(value) {
  if (is.null(value)) {
    return(NA)
  }
  return(value)
}


check_package_installed <- function(package = "testthat") {
  .check <- FALSE
  try({
    .check <- rlang::is_installed(package)
  })

  return(.check)
}

get_input_from_user <- function(prompt = "Enter any number : ", as.int = T, default.when.testing = 1) {
  if (check_package_installed("testthat") && testthat::is_testing()) {
    return(default.when.testing)
  }
  var <- readline(prompt = prompt)
  if (as.int) {
    var <- as.integer(var)
  }

  var
}
get_user_choice_cache_folder <- function() {
  msg1 <- '
    While requesting from data sources if you like to use more efficient requests you may
    choose cache = T in that case Rapi package saves the result of the requests to a temporary
    folder or any folder you may like.
    if you like to define another folder manually you may do so by

    options("Rapi_cache_folder" = "./caches_Rapi" )
    '
  .blue_force(msg1)

  msg2 <- "
    If you approve the script will create a caches folder in your current working folder
    1 - I approve a `caches_Rapi` folder in my current working folder
    2 - I would like to go with a temporary folder for this session
                 [{tempdir()}]
    3 - No, I do not like any cache option I prefer making a new request every time.

    "
  .blue_force(msg2)

  ans <- get_input_from_user("?", default.when.testing = 1)
  ans
}


which_cache_folder <- function(ans = 1) {
  list_a <- list(
    "1" = "./caches_Rapi",
    "2" = tempdir(),
    "3" = "null"
  )

  if (!toString(ans) %in% names(list_a)) {
    return("null")
  }

  list_a[[toString(ans)]]
}
# =============================================================get_cache_folder
get_cache_folder <- function(forget = FALSE) {
  folder <- getOption("Rapi_cache_folder_session")
  if (isFALSE(forget) && !is.null(folder)) {
    return(folder)
  }
  ans <- get_user_choice_cache_folder()
  cache_folder <- which_cache_folder(ans)


  options("Rapi_cache_folder_session" = cache_folder)
  if (cache_folder_is_valid(cache_folder)) {
    return(
      file.path(cache_folder)
    )
  }
  NA
}
# ==============================================================================
# this will check users choice only if cache option is True when get_series
# function was called.
# User will be asked for a location to save cache data.
# either current work folder or a temporary folder or none will be used as a location
# to save caches if current folder was approved caches_Rapi folder will be created to save data.
# ================================================= check_users_choice_if_cache=
check_users_choice_if_cache <- function(cache = FALSE) {
  if (isFALSE(cache) || !is.null(getOption("Rapi_cache_folder_asked"))) {
    return(inv(character()))
  }
  get_cache_folder(T)
  options("Rapi_cache_folder_asked" = "true")
}





cache_folder_is_valid <- function(folder = "null") {
  if (to_string(folder) == "null") {
    return(FALSE)
  }

  .check <- is.character(folder) && length(folder) == 1

  inv(.check)
}

#--------------------------------------------------------------------save_cache
save_cache <- function(name, data) {
  name <- vector_patch_cache_name(name)
  cache_folder <- get_cache_folder()

  if (!cache_folder_is_valid(cache_folder)) {
    return(data)
  }

  create_dir_if_not(cache_folder)
  saved <- false

  try({
    saveRDS(data, file.path(cache_folder, name_format_cache(name)))
    saved <- true
  })

  if (saved) {
    cache_message_conditional(SYMB_CACHE_SAVED)
  }
  data
}
hash_func <- function(name) {
  g <- paste0(name, collapse = "_")
  name2 <- digest::digest(g)
  name2
}
returning_cache_looks_good <- function(..., .cache = T) {
  cache_name <- create_cache_name_from_params(...)

  cache_opt <- should_I_check_cache(.cache)
  if (cache_opt && check_cache(cache_name)) {
    return(T)
  }
  return(F)
}
load_cache_params <- function(..., .cache = T) {
  cache_name <- create_cache_name_from_params(...)
  return(load_cache(cache_name))
}
create_cache_name_from_params <- function(...) {
  dots <- rlang::list2(...)
  v <- unlist(dots)
  h <- hash_func(v)
  h
}
vector_patch_cache_name <- function(name) {
  v_ersion <- "v" # version[["_version"]]
  g <- paste0(name, collapse = "_", v_ersion)
  name2 <- digest::digest(g)
  name2
}
cache_name_hash <- function(name) {
  name <- vector_patch_cache_name(name)
}
check_cache <- function(name) {
  cache_folders <- get_cache_folder()

  if (!cache_folder_is_valid(cache_folders)) {
    return(false)
  }

  name <- cache_name_hash(name)
  sh_name_ <- substr(name, 1, 5)

  .green("checking cache {sh_name_}")

  for (folder in cache_folders) {
    if (file.exists(file.path(folder, name_format_cache(name)))) {
      cache_message_conditional(SYMB_CACHE_FOUND)
      return(true)
    }
  }
  return(false)
}
check_cache_comp <- function(cache_name, .cache = F) {
  .cache && check_cache(cache_name)
}
check_cache2 <- function(name, .cache = T) {
  opt_ <- should_I_check_cache(.cache)
  opt_ && check_cache(name)
}

cache_message_conditional <- function(symbl = "[saved]") {
  if (check_verbose_option()) {
    success(symbl)
  }
}



#--------------------------------------------------------------------load_cache
load_cache <- function(name) {
  cache_folders <- get_cache_folder()

  if (!cache_folder_is_valid(cache_folders)) {
    return(NA)
  }

  name <- vector_patch_cache_name(name)
  for (folder in cache_folders) {
    if (file.exists(file.path(folder, name_format_cache(name)))) {
      okunan <- NA
      try({
        okunan <- readRDS(file.path(folder, name_format_cache(name)))
        cache_message_conditional(SYMB_CACHE_LOAD)
        return(okunan)
      })
      return(okunan)
    }
  }
}
# check_cache ...
#--------------------------------------------------------------------gunluk_cache
monthly_cache <- function() {
  return(format(as.POSIXct(Sys.time()), "%Y_%m"))
}
weekly_cache <- function() {
  return(sprintf(
    "%s_%s", format(as.POSIXct(Sys.time()), "%Y"),
    lubridate::isoweek(lubridate::ymd(Sys.Date()))
  ))
}
daily_cache <- function() {
  return(format(as.POSIXct(Sys.time()), "%Y_%m_%d"))
}
hourly_cache <- function() {
  return(format(as.POSIXct(Sys.time()), "%Y_%m_%d[%H]"))
}
minutely_cache <- function() {
  return(format(as.POSIXct(Sys.time()), "%Y_%m_%d[%H%M]"))
}
default_cache_period <- weekly_cache

#------------------------------------------------------------ name_format_cache
name_format_cache <- function(name) {
  period <- default_cache_period()

  paste(name, period, "CACHE.RData", sep = "_")
}
#------------------------------------------------------------ check_cache
cache_name_format <- function(func, ID = "_") {
  if (is.function(func)) {
    func <- quote(func)
  }
  paste(func, ID, sep = "_")
}
create_folder_safe <- function(folder) {
  folder <- file.path(folder)
  if (!dir.exists(folder)) {
    .green(
      "folder was created... {folder}"
    )
    try({
      dir.create(folder, recursive = TRUE)
    })
  }
}
# ===============================================================create_dir_if_not
create_dir_if_not <- function(folder) {
  create_folder_safe(folder)
}
