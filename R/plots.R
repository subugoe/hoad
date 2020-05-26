#' Color palettes
#' Colors used in the hybrid open access dashboard, based on [metaR::ugoe_pal()]
#' @family visualisation functions
#' @name colors
NULL

#' @describeIn colors licenses
#' @export
colors_license <- c(
  `cc-by` = "#153268",
  `cc-by-nc` = "#006597",
  `cc-by-nc-nd` = "#0093c7",
  `cc-by-nc-sa` = "#84BFEA",
  `publisher specific` = "#B52141",
  `other` = "#454545"
)

#' @describeIn colors other types of OA license information detected by Unpaywall
#' @export
colors_license_unpaywall <- c(
  # TODO there must not be a linebreak in the label
  `Crossref immediate license` = "#153268",
  `Other license information\n(Unpaywall)` = "#454545"
)

#' @describeIn colors sources of disclosure of OA sponsorship
#' @export
colors_source_disclosure <- c(
  `Open APC (TA)` = "#0093c7",
  `Open APC (Hybrid)` = "#84BFEA",
  `SCOAP<sup>3</sup>` = "#006597",
  # TODO in some datasets this is coded as
  `SCOAP³` = "#006597"
  # TODO NA value must be set in ggplot2 call
  # `NA` = "#E9E1D7"
)
