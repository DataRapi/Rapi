test_that("get_series works", {
  expect_equal(
    {
      obj <- get_series(template_test(), debug = T)

      is_Rapi_GETPREP(obj)
      # all(
      #   is.data.frame(obj$lines$data[[1]]),
      #   is.data.frame(obj$lines$data[[2]]),
      #   is.data.frame(obj$lines$data[[3]])
      # )
    },
    T
  )
})
