test_that("hybrid_publications dataset is sane", {
  expect_factor(hybrid_publications()$license)
  # TODO add more here once that makes sense
})
test_that("summary by journal and publisher", {
  purrr::walk(
    .x = articles_by_jp()$n,
    .f = checkmate::expect_count,
    na.ok = FALSE,
    null.ok = FALSE
  )
})
