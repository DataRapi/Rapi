test_that("print.Rapi_GETPREP works", {
  expect_equal(
    {
      #   template <- "
      # UNRATE        #fred (series)
      # bie_abreserv  #evds (table)
      # TP.AB.B1      #evds (series)
      #
      #   "
      template <- "
     TP.AB.B1
      "
      a <- get_series(template, freq = "month", start_date = "2006/01/30", debug = T)
      print(a)
      is_Rapi_GETPREP(a)
    },
    T
  )
})
