test_that("quarter_evds works", {
  expect_equal(
    {
      template <- "
          TP.BISBORCORAN.QBE
      TP.BISBORCORAN.QBR
      TP.BISBORCORAN.QCA
      TP.BISBORCORAN.QCH
      TP.BISBORCORAN.QCN
      TP.BISBORCORAN.QCZ
      TP.BISBORCORAN.QDE
      TP.BISBORCORAN.QDK
      TP.BISBORCORAN.QES
      TP.BISBORCORAN.QFI
      TP.BISBORCORAN.QFR
      "
      o <- get_series(template, start_date = "2006/01/01", debug = T)
      # is.data.frame(o$data) && is.data.frame(o$lines$data[[1]])
      is_Rapi_GETPREP(o)
    },
    T
  )
})
