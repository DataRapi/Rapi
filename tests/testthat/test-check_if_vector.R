test_that("check_if_vector works", {
  expect_equal(
    {
      template <- "
TP_YSSK_A1
TP_YSSK_A2
TP_YSSK_A3
TP_YSSK_A4
TP_YSSK_A5
TP_YSSK_A6
"
      correct_if_vector(template) == template
    },
    T
  )
})
