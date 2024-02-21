check_result_and_message <- function(data_router, concept) {
  if (is.null(data_router)) {
    msg <- "
             {concept} cannot be null
            "
    message(glue::glue(msg))
    stop()
  }
}
message_api_key <- function(source_name = "evds", .stop = F) {
  g <- glue::glue
  msg <- "
============================
  API KEY NOT SET {source_name}
============================
     you may save your api key such as below
     {format_message_set_api_key(source_name)}
"
  message(g(msg))
  if (.stop) {
    stop()
  }
  Sys.sleep(2)
}
