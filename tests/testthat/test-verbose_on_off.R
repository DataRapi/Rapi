test_that("verbose_on_off works", {
  expect_equal(
    {
      all(
        {
          options(Rapi_verbose = FALSE)
          FALSE == check_verbose_option()
        },
        {
          options(Rapi_verbose = TRUE)
          a <- check_verbose_option()
          a == TRUE
        },
        {
          options(Rapi_verbose = FALSE)
          FALSE == check_verbose_option()
        }
      )
    },
    T
  )
})
