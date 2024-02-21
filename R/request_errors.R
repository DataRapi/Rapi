error_list <- function() {
  nums <- c(400, 404, 423, 429, 500)
  errors <- c(
    "Bad Request",
    "Not Found",
    "Locked",
    "Too Many Requests",
    "Internal Server Error"
  )

  return(
    base::data.frame(
      nums = nums,
      errors = errors
    )
  )
}
error_means <- function(error_code = 400) {
  crayon::red(
    error_list() %>%
      dplyr::filter(nums == error_code) %>%
      .$errors
  )
}
