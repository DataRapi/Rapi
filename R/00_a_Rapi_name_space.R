create_Rapi_environment <- function() {
  Rapi_env <- base::new.env(parent = emptyenv())
  return(Rapi_env)
}


# Rapi Package namespace ......................................................
# ..................Rapi
# Rapi package env
Rapi_env <- create_Rapi_environment()

set_Rapi_test_value <- function(.value = TRUE) {
  Rapi_env$test <- .value

  .value
}

get_Rapi_test_value <- function() {
  return(Rapi_env$test)
}

switch_Rapi_test <- function() {
  Rapi_env$test <- !Rapi_env$test
}


clean_Rapi_environment <- function() {
  rm(list = ls(envir = Rapi_env), envir = Rapi_env)
}
