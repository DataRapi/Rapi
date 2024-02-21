test_that("excel works", {
  expect_equal(
    {
      o <- get_series(template_test())
      # o <- excel(o, "aa")
      is_Rapi_GETPREP(o)
    },
    T
  )
})
