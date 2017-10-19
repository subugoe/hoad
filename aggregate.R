#' #+ setup, include=FALSE
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  warning = FALSE,
  message = FALSE
)
#' # Data agregation
#' 
#' ## What's published in hybrid journals?
#'
#' ### How to retrieve a list of hybrid journals?
#'
#' To my knowledge, there's no comprehensive list of hybrid OA journals. However, a list of
#' hybrid OA journals can be compiled using the Open APC dataset curated by the
#' [Open APC Initiative](github.com/openapc/openapc-de) initiative. This initiative collects 
#' and shares institutional spending information for open access publication fees, 
#' including those spent for publication in hybrid journals.
#'
#' Let's retrieve the most current dataset:
#'
library(dplyr)
#' link to dataset
u <-
  "https://raw.githubusercontent.com/OpenAPC/openapc-de/master/data/apc_de.csv"
o_apc <- readr::read_csv(u) %>%
  filter(is_hybrid == TRUE)
#' Some summary statistics:
#'
#' We also would like to add data from offsetting aggrements, which is also collected
#' Open APC initiative, but does not include pricing information.
#' 
o_offset <- readr::read_csv("https://raw.githubusercontent.com/OpenAPC/openapc-de/master/data/offsetting/offsetting.csv")
#' Merge with Open APC dataset
o_apc <- o_offset %>% 
  mutate(euro = as.integer(euro)) %>% 
  bind_rows(o_apc) 
#' some summary sttatistics by publishers (top 10)
o_apc %>%
  mutate(publisher = forcats::fct_lump(publisher, n = 10)) %>%
  count(publisher) %>%
  mutate(prop = n / sum(n))
#' ## How does it relate to the general hybrid output per journal?
#'
#' Crossref Metadata API is used to get both license information and number of articles
#' published per year. The API is accessed via
#' [rOpenSci's rcrossref client](https://github.com/ropensci/rcrossref).
#'
#' Instead of fetching all articles published, we use facet counts to keep API usage low
#'
#' <https://github.com/CrossRef/rest-api-doc/#facet-counts>
#'
#' There are two steps:
#'
#' First, retrieve journal article volume and corresponding licensing information 
#' for the period  2013 - 2016
jn_facets <- purrr::map("0001-706X", .f = function(x) {
  issn <- x
  tt <- rcrossref::cr_works(
    filter = c(issn = issn, 
             from_pub_date = "2013-01-01", 
             until_pub_date = "2016-12-31",
             type = "journal-article"),
  facet = TRUE)
  #' Parse the relevant information
  #' - published volume per year
  #' - licenses
  #' - Crossref journal title (in case of journal name change, use the most frequent name)
  #' - Crossref publisher (in case of publisher name change, use the most frequent name)
  #' 
  #' To Do: switch to current potential
  tibble::tibble(
    issn = issn,
    year_published = list(tt$facets$published),
    license_refs = list(tt$facets$license), 
    journal_title = tt$facets$`container-title`$.id[1], 
    publisher = tt$facets$publisher$.id[1]
  )
  })

#' Second, filter out open licenses and check
#' 
#' #' ## Which licenses indicates hybrid OA availability?
#' 
#'  [dissemin](https://dissem.in/) compiled a list of licenses used in Crossref,
#'  which indicate OA availability. [oaDOI](https://oadoi.org) re-uses this list. 
#'  This list can be found here:
#'  
#'  <https://github.com/dissemin/dissemin/blob/0aa00972eb13a6a59e1bc04b303cdcab9189406a/backend/crossref.py#L89>
#'   license per publisher and year
#' (replace group_by argument, i.e., journal wehen you want to calculate license per journal)
#'  
#'  oaDOI added to this list  IEEE's OA license:
#'  `http://www.ieee.org/publications_standards/publications/rights/oapa.pdf`
licence_patterns <- c("creativecommons.org/licenses/",
                      "http://koreanjpathol.org/authors/access.php",
                      "http://olabout.wiley.com/WileyCDA/Section/id-815641.html",
                      "http://pubs.acs.org/page/policy/authorchoice_ccby_termsofuse.html",
                      "http://pubs.acs.org/page/policy/authorchoice_ccbyncnd_termsofuse.html",
                      "http://pubs.acs.org/page/policy/authorchoice_termsofuse.html",
                      #            "http://www.elsevier.com/open-access/userlicense/1.0/",
                      "http://www.ieee.org/publications_standards/publications/rights/oapa.pdf")
#' now add indication to the dataset
hybrid_licenses <- tt %>%
  select(journal_title, license_refs) %>%
  tidyr::unnest() %>%
  mutate(license_ref = tolower(.id)) %>%
  select(-.id) %>%
  mutate(hybrid_license = ifelse(grepl(
    paste(licence_patterns, collapse = "|"),
    license_ref
  ), TRUE, FALSE)) %>%
  filter(hybrid_license == TRUE)
#' We now know, whether and which open licenses were used by the journal in the 
#' period 2013:2016. As a next step we want to validate that these licenses were not 
#' issued for delayed open access articles by using the self-explanatory 
#' filter `license.url` and `license.delay`
tmp <- purrr::map2(hybrid_licenses$license_ref,  function(x, y) {
  u <- x
  issn <- y
  tmp <- rcrossref::cr_works(filter = c(issn = issn, 
                      license.url = u, 
                      license.delay = 0,
                      type = "journal-article",
                      from_pub_date = "2013-01-01", 
                      until_pub_date = "2016-12-31"),
           facet = TRUE) 
  tibble::tibble(
    issn =  issn,
    year_published = list(tmp$facets$published),
    license = u
  )
})
#' into one data frame!
purrr::map_df(tmp, .f = function(x) tidyr::unnest(x))
