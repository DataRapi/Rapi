message_debug <- function(msg, ...) {
  dbg_option <- getOption("Rapi_debug")
  if (isFALSE(dbg_option)) {
    return(invisible(T))
  }
  message(...)
  .blue("[dbg]->
        {msg}")
}
excel_internal <- function(
    dfs = null,
    file_name = "d1.xlsx",
    folder = null,
    .debug = T,
    env = rlang::caller_env(),
    ...) {
  message_func <- message_debug
  if (is_Rapi_GETPREP(dfs)) {
    # Dispatch
    obj <- dfs

    listx <- list()

    for (num in seq(nrow(obj$lines))) {
      .name <- obj$lines$index[[num]]
      .data <- obj$lines$data[[num]]

      if (is.data.frame(.data)) {
        listx[[.name]] <- .data
      }
    }
    dfs_ <- c(list(combined = obj$data), listx)
    excel(dfs_, folder = folder, file_name = file_name)
    return(obj)
  }
  if (inherits(dfs, "data.frame") && !nrow(dfs)) {
    listex <- list(file_name = file_name, dfs = dfs)
    # assign_("DBG_excel_listex" , listex )
    message_func("Empty data.frame(0)")
    message_func("-->")
    message_func(file_name)
    message_func("\n\r\n\r")
    return(invisible(1))
  }
  if (!inherits(dfs, "list") && !inherits(dfs, "data.frame")) {

    message_func("excel function requires data.frame or list of data.frames(1)")
    return(invisible(1))
  }
  if (!len(dfs)) {

    message_func("excel function requires data.frame or list of data.frames(2)")
    return(invisible(2))
  }
  if (is.list(dfs) && !is.data.frame(dfs)) {
    if (!all(unlist(purrr::map(dfs, \(x) inherits(x, "data.frame"))))) {
      dfs <- filter_list_df(dfs)
      if (!len(dfs)) {
        message_func("excel function requires data.frame or list of data.frames(3)")
        return(invisible(3))
      }
    }
  }
  dfs <- check_rehber(dfs)

  if (is.null(folder)) {
    folder <- "."
  }
  create_dir_if_not(folder)
  if (is.null(file_name)) {
    file_name <- "UnnamedFileRapi.xlsx"
  }
  if (!grepl("xlsx", file_name)) {
    file_name <- paste0(file_name, ".xlsx")
  }
  core_file_name <- stringr::str_split_1(file_name, ".xlsx")[[1]]

  ok <- F
  try({
    file_name <- file.path(folder, file_name)
    writexl::write_xlsx(dfs, file_name)
    ok <- T
    .blue("folder: {folder}\n\r")
    success_force(glue::glue(" \n\r\n\r [excel] writing [ { core_file_name }] \n\r\n\r"))
  })
  # .......................................................... hash
  if (isFALSE(ok)) {
    file_name_backup <- sprintf("%s-%s", core_file_name, get_hash(5)[[1]])
    file_name_backup <- file.path(folder, file_name_backup)
    .blue("folder: {folder}\n\r")
    success_force(glue::glue(" \n\r\n\r [excel] writing [ { file_name_backup }] \n\r\n\r"))
  }
  # ..........................................................
  invisible(dfs)
}
