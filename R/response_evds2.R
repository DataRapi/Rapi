convert_list_df_evds2 <- function(items) {
  lines_ <- NULL
  for (item in items) {
    line <- getLineEvdsResponse2(item)
    if (is.null(lines_)) {
      try({
        lines_ <- as.data.frame(line)
      })
    } else {
      try({
        lines_ <- rbind(lines_, line)
      })
    }
  }
  tb <- tibble::as_tibble(lines_)
  tb
}
