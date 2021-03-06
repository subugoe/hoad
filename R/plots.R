#' Color palettes
#' Colors used in the hybrid open access dashboard, based on [subugoetheme::ugoe_pal()]
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
  `Crossref immediate license` = "#153268",
  # TODO there must not be a linebreak in the label
  `Other license information\n(Unpaywall)` = "#454545"
)

#' @describeIn colors sources of disclosure of OA sponsorship
#' @export
colors_source_disclosure <- c(
  `Open APC (TA)` = "#0093c7",
  `Open APC (Hybrid)` = "#84BFEA",
  # TODO remove these non ascis; cause warnings https://github.com/subugoe/hoad/issues/193
  `SCOAP<sup>3</sup>` = "#006597",
  # TODO in some datasets this is coded as
  `SCOAP³` = "#006597"
  # TODO NA value must be set in ggplot2 call
  # `NA` = "#E9E1D7"
)
