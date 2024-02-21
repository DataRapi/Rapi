#' Sets the cache folder or changes it if it was already set to save caches.
#'
#' @param folder Folder to set as a cache folder. The default value is NULL,
#' which triggers the check_users_choice_if_cache function that provides some
#' options to the user to use it as a cache folder, a temporary one, or disable caching.
#' @param verbose Boolean. If TRUE, it provides information when the
#' cache folder is set. Otherwise, it only prints a warning when there is an error.
#' @return No return value, called for side effects
#' @export
#'
#' @examples
#' change_cache_folder("my_cache_folder", verbose = TRUE)
change_cache_folder <- function(folder = null, verbose = FALSE) {
  if (is.null(folder)) {
    return(get_cache_folder(forget = TRUE))
  }
  options("Rapi_cache_folder_session" = folder)
  if (verbose) {
    success_force("cache folder was set [{folder }]")
  }

  inv(NULL)
}
