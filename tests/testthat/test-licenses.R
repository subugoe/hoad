test_that("urls are valid", {
  purrr::walk(
    .x = license_patterns$url,
    .f = function(x) {
      expect_list(httr::parse_url(x))
    }
  )
})
