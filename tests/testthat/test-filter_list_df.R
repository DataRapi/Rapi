test_that("filter_list_df works", {
  expect_equal(
    {
      df <- data.frame(a = 1:5)


      df_list <- list(df, df)

      df_list2 <- list(df, NA, a = df)
      d <- filter_list_df(df_list2)
      d <- filter_list_df(df_list)

      is.list(d)
    },
    T
  )
})
