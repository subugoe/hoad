#' Open Access Articles by License and Year
#' @export
#' @examples
#' oa_by_license()
#' @family ETL functions
oa_by_license <- function() {
  hybrid_publications() %>%
    group_by(.data$license, .data$issued, .drop = FALSE) %>%
    summarise(absolute = n())
}

#' @describeIn oa_by_license Plot by License and Year
#' @examples
#' oa_by_license_plot()
#' @family visualisation function_
#' @export
oa_by_license_plot <- function() {
  ggplot(
    data = oa_by_license(),
    mapping = aes(x = .data$issued, y = .data$absolute, fill = .data$license),
  ) +
    scale_x_discrete(drop = FALSE) +
    geom_col()
}
