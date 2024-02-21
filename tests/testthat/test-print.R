test_that("print works", {
  expect_equal(
    {
      o <- get_series(template_test(), cache = T, debug = T)
      p <- capture.output({
        print(o)
      })

      length(p) > 30
    },
    T
  )
})
