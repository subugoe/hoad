#' Hybrid open access articles via [Crossref](https://www.crossref.org)
#' 
#' Contains information about the overall publication volume, and, if available, cost information from the Open APC Initiative.
#' 
#' @format 
#' A data frame with the following variables:
#' 
#' | **Variable**               | **Description**                                                    |
#' | -------------------------- | ------------------------------------------------------------------ |
#' | `license`                  | Normalized open content license statement                          |
#' | `journal_title`            | Most frequent journal title used by Crossref                       |
#' | `publisher`                | Most frequent publisher name used by Crossref                      |
#' | `doi_oa`                   | DOI of the hybrid open access article                              |
#' | `issued`                   | Earliest publication year                                          |
#' | `yearly_jn_volume`         | Yearly article volume per journal                                  |
#' | `license_ref_n`            | Yearly article volume under the license `license`                  |
#' | `yearly_publisher_volume`  | Yearly article volume of all journals in the dataset per publisher |
#' | `yearly_all`               | Yearly article volume investigated                                 |
#' | `period`                   | Year of reporting to Open APC                                      |
#' | `euro`                     | The amount that was paid in EURO. Includes VAT and additional fees |
#' | `hybrid_type`              | Spending source (Open APC, SCOAP3)                                 |
#' | `institution`              | Top-level organisation which reported article to Open APC          |
#' | `country`                  | Country of origin (iso3c)                                          |
#' | `country_name`             | Country of origin (name)                                           |
#' | `license_url`              | License URL                                                        |
#' | `host`                     | Email host first or corresponding author                           |
#' | `subdomain`                | Email subdomain first or corresponding author                      |
#' | `domain`                   | Email domain first or corresponding author                         |
#' | `suffix`                   | Email suffix first or corresponding author                         |
#' 
#' @source [Crossref](https://www.crossref.org)
#' 
#' @section License:
#' See Crossref [Terms and Conditions](https://www.crossref.org/requestaccount/termsandconditions.html)
#' 
#' @export
# storing this as an object ensures this is read in only at compile time, not run time
# downside: automatic collation order does not work for objects (instead of functions), so this file needs to be called zzz and called last
hybrid_publications <- read_csv(
  file = path_extdat("hybrid_publications.csv"),
  col_types = cols(
    license = col_factor(),
    journal_title = col_factor(),
    publisher = col_factor(),
    doi_oa = col_character(),
    issued = col_integer(),
    yearly_jn_volume = col_integer(),
    license_ref_n = col_integer(),
    yearly_publisher_volume = col_integer(),
    yearly_all = col_integer(),
    institution = col_factor(),
    period = col_integer(),
    euro = col_double(),
    hybrid_type = col_factor(),
    country = col_factor(),
    country_name = col_factor(),
    license_url = col_factor(),
    host = col_character(),
    subdomain = col_character(),
    domain = col_character(),
    suffix = col_character()
  )
)
  
#' Unpaywall data
# TODO improve docs
#' @export
unpaywall_df <- readr::read_csv(
  file = path_extdat("unpaywall_df.csv"),
  col_types = cols(
    year = col_integer(),
    journal_title = col_factor(),
    source = col_factor(),
    articles = col_integer()
  )
)
