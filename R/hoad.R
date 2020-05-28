#' @import dplyr
#' @import readr
#' @import checkmate
#' @import ggplot2
#' @importFrom rlang .data
#' @keywords internal
"_PACKAGE"

#' Start hoad web application
#' @inheritDotParams shiny::runApp
#' @inherit shiny::runApp
#' @family CICD
#' @export
runHOAD <- function(...) {
  rmarkdown::run(file = system.file("app", "dashboard.Rmd", package = "hoad"), ...)
}
