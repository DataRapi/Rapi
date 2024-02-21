test_that("assign_data_funcs works", {
  expect_equal(
    {
      a <- get_series(template_test())
      a <- assign_data_funcs(a)
      isTRUE("fnc_str" %inn% a$lines)
    },
    T
  )
})
