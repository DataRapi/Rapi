null <- NULL
false <- F
true <- T
# CURRENT_VERSION <- "1.0.3"
#
#
# get_current_package_vers <- function() {
#   CURRENT_VERSION
# }


globalVariables(c(
  "nums", "everything", "Tarih",
  "fnc_str", "tarih", ".", "base"
))

#' template_test
#' creates a string template for testing and example purposes
#'
#' @return a string template that includes ID examples from different sources
#'
#' @export
#'
#' @examples
#' template_test()
template_test <- function() {
  "
    UNRATE        #fred (series)
    bie_abreserv  #evds (table)
    TP.AB.B1      #evds (series)
    "
}
