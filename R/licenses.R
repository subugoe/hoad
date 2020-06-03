#' URL components for open access licenses
#'
#' Metadata sometimes do not include structured data on the openess of a license, but only URLs to full license texts.
#' These URL components are taken as an indication that an article is under an open license.
#'
#' @format
#' A data frame with the following variables:
#'
#' - url:
#'   the URL components (domain and path) to licenses
#' - source:
#'   the source which first identified the license URL as indicating open source.
#'   For details, see source.
#'
#' @source
#' - `dissemin`:
#'   [dissemin](https://dissem.in/) compiled a list of licenses used in Crossref,
#' which indicate OA availability.
#'   [oaDOI](https://oadoi.org) re-uses this list.
#'   This list has been downloaded from the [dissemin source on github](https://github.com/dissemin/dissemin/blob/0aa00972eb13a6a59e1bc04b303cdcab9189406a/backend/crossref.py#L89)
#' - `oadoi`:
#'    [oaDOI](https://oadoi.org) also accepted these urls as per a [github issue](https://github.com/ourresearch/oadoi/issues/49).
#'
#' @examples
#' license_patterns
#' @family data
#' @export
license_patterns <- tibble::tribble(
  # TODO these should be all be tested etc. https://github.com/subugoe/hoad/issues/215
  # TODO these should also probably be stored as proper URLs https://github.com/subugoe/hoad/issues/217
  ~url, ~source,
  "creativecommons.org/licenses/", "dissemin",
  # TODO this is one is odd https://github.com/subugoe/hoad/issues/214
  "http://koreanjpathol.org/authors/access.php", "dissemin",
  "http://olabout.wiley.com/WileyCDA/Section/id-815641.html", "dissemin",
  "http://pubs.acs.org/page/policy/authorchoice_ccby_termsofuse.html", "dissemin",
  "http://pubs.acs.org/page/policy/authorchoice_ccbyncnd_termsofuse.html", "dissemin",
  "http://pubs.acs.org/page/policy/authorchoice_termsofuse.html", "dissemin",
  # TODO may need to be evaluated https://github.com/subugoe/hoad/issues/216
  "http://www.elsevier.com/open-access/userlicense/1.0/", "dissemin",
  "http://www.ieee.org/publications_standards/publications/rights/oapa.pdf", "oadoi",
  "http://aspb.org/publications/aspb-journals/open-articles", "oadoi",
  "https://doi.org/10.1364/OA_License_v1", "oadoi"
)
