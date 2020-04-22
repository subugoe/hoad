test_that("hybrid_publications dataset is sane", {
  expect_factor(hybrid_publications()$license)
  # TODO add more here once that makes sense
})
