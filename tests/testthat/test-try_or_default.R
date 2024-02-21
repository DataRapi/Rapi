test_that("try_or_default works", {
  expect_equal(
    {
      a <- try_or_default(
        {
          1 / 18
        },
        .default = 18
      )
      b <- try_or_default(
        {
          1 / asd
        },
        .default = 18
      )
      isTRUE(a < 1 && b == 18)
    },
    T
  )
})
