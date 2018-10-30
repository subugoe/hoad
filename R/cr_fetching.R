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
#' To my knowledge, there's no comprehensive list of hybrid OA journals. However,
#' a list of hybrid OA journals can be compiled using the Open APC dataset curated
#' by the [Open APC Initiative](github.com/openapc/openapc-de) initiative.
#' This initiative collects  and shares institutional spending information for
#' open access publication fees, including those spent for publication in
#' hybrid journals.
#'
#' Let's retrieve the most current dataset:
#'
library(tidyverse)
#' link to dataset
u <-
  "https://raw.githubusercontent.com/OpenAPC/openapc-de/master/data/apc_de.csv"
o_apc <- readr::read_csv(u) %>%
  filter(is_hybrid == TRUE)
#'
#' We also would like to add data from offsetting aggrements, which is also
#' collected by the Open APC initiative.
#' The offsetting data-set does not include pricing information.
#'
o_offset <-
  readr::read_csv(
    "https://raw.githubusercontent.com/OpenAPC/openapc-de/master/data/offsetting/offsetting.csv"
  )
#' Merge with Open APC dataset
o_apc <- o_offset %>%
  mutate(euro = as.integer(euro)) %>%
  bind_rows(o_apc) %>%
  # start from 2013
  filter(period > 2012) %>%
  # data cleaning
  # 1. wrong journal title for 10.1136/svn-2016-000035
  mutate(
    journal_full_title = ifelse(
      issn %in% "2059-8688",
      "Stroke and Vascular Neurology",
      journal_full_title
    )
  ) %>%
  # 2. map all Angewandte Chemie articles to the international edition
  mutate(issn = ifelse(issn %in% "0044-8249", "1433-7851", issn)) %>%
  # also change DOIs accordingly
  mutate(doi = str_replace(doi, "10.1002/ange.", "10.1002/anie.")) %>%
  # 3. use Springer Nature
  mutate(
    publisher = ifelse(
      publisher %in% "Springer Science + Business Media",
      "Springer Nature",
      publisher
    )
  ) %>%
  # 4. remove all publications from fully OA publisher copernicus 
  filter(!publisher %in% "Copernicus GmbH") %>%
  # 5. remove STEM CELLS Translational Medicine, a fully OA journal
  # since 2012
  # https://github.com/subugoe/hybrid_oa_dashboard/issues/10
  filter(!journal_full_title == "STEM CELLS Translational Medicine") %>%
  # 5. distinguish between individual hybrid and offsetting
  mutate(hybrid_type = ifelse(!is.na(euro), "Open APC (Hybrid)", "Open APC (Offsetting)"))
#' Include country information, which are available via Open APC OLAP server: 
#' <https://github.com/OpenAPC/openapc-olap/blob/master/static/institutions.csv>
country_apc <- readr::read_csv("https://raw.githubusercontent.com/OpenAPC/openapc-olap/master/static/institutions.csv") %>%
  select(institution, country)
countries <- readr::read_csv("https://raw.githubusercontent.com/OpenAPC/openapc-olap/master/static/institutions_offsetting.csv") %>%
  bind_rows(country_apc) %>%
  distinct() %>% 
  mutate(country_name = countrycode::countrycode(country, "iso3c", "country.name"))
#' merge with open apc dataset
#' 
o_apc <- o_apc %>%
  left_join(countries, by = "institution")
#' open apc dump
readr::write_csv(o_apc, "../data/oapc_hybrid.csv")
#' ## How does it relate to the general hybrid output per journal?
#'
#' Crossref Metadata API is used to gather both license information and
#' the number of articles published per year for the period 2013 - 2018.
#' The API is accessed with [rOpenSci's rcrossref client](https://github.com/ropensci/rcrossref).
#'
#' Instead of fetching all articles published, we use facet counts to keep API usage low
#'
#' <https://github.com/CrossRef/rest-api-doc/#facet-counts>
#'
#' This involves two steps:
#'
#' First, we retrieve journal article volume and corresponding licensing information
#' for the period  2013 - 2018 for all issns per journal in the Open APC dataset.
#'
#' Let's gather the issn's
o_apc %>%
  distinct(issn,
           issn_print,
           issn_electronic,
           journal_full_title,
           publisher) %>%
  gather(issn,
         issn_print,
         issn_electronic,
         key = "issn_type",
         value = "issn") %>%
  filter(!is.na(issn)) %>%
  distinct(issn, .keep_all = TRUE) -> o_apc_issn
#' Show journals with more than two issns
o_apc_issn %>%
  group_by(journal_full_title, publisher) %>%
  filter(n() > 2) %>%
  arrange(journal_full_title)
#' Next, we will retrieve the yearly publication volume for each journal.
#' We want to apply mutliple filters on issn, which results in an OR search
#'
#' create a data frame wiht distinc journal_title and publisher names
distinct_combs <- o_apc_issn %>%
  distinct(publisher, journal_full_title)
#' create multiple issn filters
issns_list <-
  purrr::map2(distinct_combs$publisher, distinct_combs$journal_full_title, function(x, y) {
    issns <- o_apc_issn %>%
      filter(publisher == x, journal_full_title == y) %>%
      .$issn
    names(issns) <- rep("issn", length(issns))
    as.list(issns)
  })
#' search crossref
jn_facets <- purrr::map(issns_list, .f = purrr::safely(function(x) {
  tt <- rcrossref::cr_works(
    filter = c(
      x,
      from_pub_date = "2013-01-01",
      until_pub_date = "2018-12-31",
      type = "journal-article"
    ),
    facet = TRUE,
    # less api traffic
    select = "DOI"
  )
  #' Parse the relevant information
  #' - `issn` - issns  found in open apc data set
  #' - `year_published` - published volume per year (Earliest year of publication)
  #' - `license_refs` - facet counts for license URIs of work
  #' - `journal_title` - Crossref journal title (in case of journal name change, we use the most frequent name)
  #' - `publisher` - Crossref publisher (in case of publisher name change, we use the most frequent name)
  #'
  #' To Do: switch to current potential
  if (!is.null(tt)) {
    tibble::tibble(
      issn = list(x),
      year_published = list(tt$facets$published),
      license_refs = list(tt$facets$license),
      journal_title = tt$facets$`container-title`$.id[1],
      publisher = tt$facets$publisher$.id[1],
      category = list(tt$facets$`category-name`$.id)
    )
  } else {
    NULL
  }
}))
#' Dump:
jn_facets_df <- purrr::map_df(jn_facets, "result")
jsonlite::stream_out(jn_facets_df, file("../data/jn_facets_df.json"))
#' Second, filter out open licenses and check:
#' 
#' Question: Which licenses indicates hybrid OA availability?
#' 
#' [dissemin](https://dissem.in/) compiled a list of licenses used in Crossref,
#' which indicate OA availability. [oaDOI](https://oadoi.org) re-uses this list. 
#' This list can be found here:
#'  
#' <https://github.com/dissemin/dissemin/blob/0aa00972eb13a6a59e1bc04b303cdcab9189406a/backend/crossref.py#L89>
#'  license per publisher and year
#' (replace group_by argument, i.e., journal wehen you want to calculate license per journal)
#'  
#'  oaDOI added to this list  IEEE's OA license:
#'  `http://www.ieee.org/publications_standards/publications/rights/oapa.pdf`
#'  
#'  We include Elseviers Open Access license, needs more evaluation
licence_patterns <- c("creativecommons.org/licenses/",
                      "http://koreanjpathol.org/authors/access.php",
                      "http://olabout.wiley.com/WileyCDA/Section/id-815641.html",
                      "http://pubs.acs.org/page/policy/authorchoice_ccby_termsofuse.html",
                      "http://pubs.acs.org/page/policy/authorchoice_ccbyncnd_termsofuse.html",
                      "http://pubs.acs.org/page/policy/authorchoice_termsofuse.html",
                      "http://www.elsevier.com/open-access/userlicense/1.0/",
                      "http://www.ieee.org/publications_standards/publications/rights/oapa.pdf",
                      # we also add @ioverka suggestions:
                      # https://github.com/Impactstory/oadoi/issues/49 :
                      "http://aspb.org/publications/aspb-journals/open-articles",
                      "https://doi.org/10.1364/OA_License_v1")
#' now add indication to the dataset
hybrid_licenses <- jn_facets_df %>%
  select(journal_title, publisher, license_refs) %>%
  tidyr::unnest() %>%
  mutate(license_ref = tolower(.id)) %>%
  select(-.id) %>%
  mutate(hybrid_license = ifelse(grepl(
    paste(licence_patterns, collapse = "|"),
    license_ref
  ), TRUE, FALSE)) %>%
  filter(hybrid_license == TRUE) %>%
  left_join(jn_facets_df, by = c("journal_title" = "journal_title", "publisher" = "publisher"))
#' We now know, whether and which open licenses were used by the journal in the 
#' period 2013:2018. As a next step we want to validate that these 
#' licenses were not issued for delayed open access articles by 
#' additionally using  the self-explanatory filter `license.url` and
#'  `license.delay`. We also obtain parsed metadata for these hybrid open
#'  access articles stored as list-column.
cr_license <- purrr::map2(hybrid_licenses$license_ref, hybrid_licenses$issn,
                          .f = purrr::safely(function(x, y) {
                            u <- x
                            issn <- y
                            tmp <- rcrossref::cr_works(filter = c(issn, 
                                                                  license.url = u, 
                                                                  license.delay = 0,
                                                                  type = "journal-article",
                                                                  from_pub_date = "2013-01-01", 
                                                                  until_pub_date = "2018-12-31"),
                                                       cursor = "*", cursor_max = 5000L, 
                                                       limit = 1000L) 
                            tibble::tibble(
                              issn =  list(issn),
                              year_published = list(tmp$facets$published),
                              license = u,
                              md = list(tmp$data)
                            )
                          }))
#' into one data frame!
#' dump it
cr_license_df <- cr_license %>% 
  purrr::map_df("result") 
#' all, results into a large file, which won't be tracked with GIT
dplyr::bind_rows(cr_license_df$md) %>% 
  jsonlite::stream_out(file("../data/hybrid_license_md.json"))
#' only DOIs and how we retrieved them
purrr::map(cr_license_df$md, "DOI") %>%
  data_frame(dois = ., issn = cr_license_df$issn, license = cr_license_df$license) %>%
  jsonlite::stream_out(file("../data/hybrid_license_dois.json"))

