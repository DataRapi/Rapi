on_development_read_api_keys_of_developers <- function() {
  file_name <- file.path("..", "api_keys.txt")

  if (!file.exists(file_name)) {
    return("FileNotFound")
  }
  content <- read(file_name)
  assign_apikey <- function(parts) {
    if (length(parts) < 2) {
      return(character())
    }
    source_name <- sp_trim(parts[1])
    key <- sp_trim(parts[2])
    if (source_name %in% c("evds", "fred")) {
      set_api_key(key, source_name)
    }
  }
  split <- stringr::str_split_1
  lines <- split(content, "\n")
  for (line in lines) {
    parts <- split(line, "=")
    assign_apikey(parts)
  }
}
before_check <- function() {
  on_development_read_api_keys_of_developers()
  # system( "R CMD check --as-cran ." , stdout = T  )
  content <- system2("R",
    c(
      "CMD",
      "check",
      "--as-cran",
      "."
    ),
    stdout = T
  )
  content <- paste0(content, collapse = "\n")
  cat(content,
    file = file.path(
      "logs",
      sprintf(
        "CMD_CHECK_RESULTS-%s.txt",
        get_hash(1)
      )
    )
  )
  content
}
