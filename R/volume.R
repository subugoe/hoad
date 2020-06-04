# oa by license ====
#' Open Access Articles by Year and License
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

# oa other ====
#' Open Access Articles by Year and License Statement
#'
#' *Additional* license information (compared to [oa_by_license()]) as detected by Unpaywall.
#'
#' @param x a data frame like its default, [unpaywall_df()]
#'
#' @param by_pub giving whether to group by summarised publishers
#'
#' @export
#'
#' @examples
#' oa_by_other()
#' @family ETL functions
oa_by_other <- function(x = unpaywall_df(), by_pub = FALSE) {
  checkmate::assert_flag(by_pub)
  if (by_pub) {
    # TODO bit awkward to summarise publishers in here; necessary for usage in about.rmd
    x <- mutate(
      .data = x,
      publisher = forcats::fct_other(
        f = .data$publisher,
        keep = c("Elsevier BV", "Springer Nature")
      )
    ) %>%
      group_by(.data$publisher)
  }
  x %>%
    group_by(.data$year, .data$source, add = TRUE) %>%
    summarise(articles = sum(.data$articles, na.rm = TRUE))
}

#' @describeIn oa_by_other plotting
# TODO the param documentation needs to be beefed up, perhaps as part of https://github.com/subugoe/hoad/issues/221
#' @param x a data frame like its default, [oa_by_other()]
#' @examples
#' oa_by_other_plot()
#' @family visualisation function
#' @export
oa_by_other_plot <- function(x = oa_by_other()) {
  ggplot(
    data = x,
    mapping = aes(
      x = .data$year,
      y = .data$articles,
      fill = .data$source
    )
  ) +
    geom_bar(stat = "identity", position = position_stack()) +
    scale_x_continuous(name = "Year", breaks = find_all_ints(x$year)) +
    scale_y_continuous(
      name = "Articles",
      labels = function(x) {
        format(x, big.mark = " ", scientific = FALSE)
      }
    ) +
    scale_fill_manual(
      name = "OA articles with",
      values = colors_license_unpaywall
    ) +
    theme_minimal() +
    theme(
      # TODO enable these https://github.com/subugoe/hoad/issues/70
      # base_family="Roboto",
      # base_size = 12
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      axis.ticks = element_blank(),
      panel.border = element_blank(),
      legend.position = "top"
    )
}
