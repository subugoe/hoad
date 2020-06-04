#' Find path for files in `/inst/extdata/`
#'
#' Looks for `inst/` in the working directory, otherwise wraps [fs::path_package()] with appropriate defaults for this package.
#'
#' @details
#' This function **will be deprecated** when all data files are retrieved via APIs.
#'
#' As a [stop-gap measure](), data files are stored in `inst/extdata/` and compiled into the package.
#' Depending on the context in which you want to use these files, their paths will differ.
#' When running from the source root, they can be found at `inst/extdata/`.
#' When the package is compiled (as in vignette use), they can be found at `extadata/`.
#'
#' This function automatically picks the correct path or throws an error if the file cannot be found.
#'
#' @param x `[character(1)]` giving the filename or path to the file from `inst/extdata/`
#'
#' @return `[character(1)]` giving the absolute path to `x`, as returned by [fs::path_abs()].
#'
#' @keywords internal
#' @export
path_extdat <- function(x) {
  checkmate::assert_string(x = x, na.ok = FALSE, null.ok = FALSE)
  if (fs::dir_exists("inst")) {
    res <- fs::path_wd(path = fs::path("inst", "extdata", x))
  } else {
    res <- fs::path_package(package = "hoad", fs::path("extdata", x))
  }
  checkmate::assert_file_exists(x = res)
  res
}

#' Find all integers inside the range of a vector
#'
#' Helpful for finding all years.
#' [unique()] is't quite the same, because it would leave out empty years, but for plots and the like there can never be empty years.
#'
#' @param x a numeric vector that can be transformed to integers (integerish)
#' @return an integer vector from min to max
find_all_ints <- function(x) {
  checkmate::assert_integerish(x)
  x <- as.integer(x)
  min(x):max(x)
}
