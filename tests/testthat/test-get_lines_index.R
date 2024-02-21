test_that("get_lines_index works", {
  expect_equal(
    {
      a <- get_lines_index()
      len(a)
    },
    3
  )
})
test_that("get_lines_as_df works", {
  expect_equal(
    {
      a <- get_lines_as_df()
      is.data.frame(a) && "base" %inn% a
    },
    true
  )
})
