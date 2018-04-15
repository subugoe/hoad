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
  # use Springer Nature
  mutate(
    publisher = ifelse(
      publisher %in% "Springer Science + Business Media",
      "Springer Nature",
      publisher
    )
  )
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
  purrr::map2(distinct_combs$publisher[1:10], distinct_combs$journal_full_title[1:10], function(x, y) {
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
      publisher = tt$facets$publisher$.id[1]
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
  select(issn, license_refs) %>%
  tidyr::unnest() %>%
  mutate(license_ref = tolower(.id)) %>%
  select(-.id) %>%
  mutate(hybrid_license = ifelse(grepl(
    paste(licence_patterns, collapse = "|"),
    license_ref
  ), TRUE, FALSE)) %>%
  filter(hybrid_license == TRUE) %>%
  left_join(jn_facets_df, by = c("issn" = "issn"))
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
                            tmp <- rcrossref::cr_works(filter = c(issn = issn, 
                                                                  license.url = u, 
                                                                  license.delay = 0,
                                                                  type = "journal-article",
                                                                  from_pub_date = "2013-01-01", 
                                                                  until_pub_date = "2018-12-31"),
                                                       facet = "published",
                                                       , limit = 1000) 
                            tibble::tibble(
                              issn =  issn,
                              year_published = list(tmp$facets$published),
                              license = u,
                              md = list(tmp$data)
                            )
                          }))
#' into one data frame!
#' dump it
cr_license_df <- cr_license %>% 
  purrr::map_df("result") 
# all, results into a large file, which won't be tracked with GIT
bind_rows(cr_license_df$md) %>% 
  jsonlite::stream_out(file("../data/hybrid_license_md.json"))
# only DOIs and how we retrieved them
map(cr_license_df$md, "DOI") %>%
  data_frame(dois = ., issn = cr_license_df$issn, license = cr_license_df$license) %>%
  jsonlite::stream_out(file("../data/hybrid_license_dois.json"))
#' prpeare indicator set
cr_license %>% purrr::map_df("result") %>% 
  select(-md) %>%
  tidyr::unnest(year_published) %>%
  #' some column renaming
  select(1:2, year = .id, license_ref_n = V1) %>%
  # TODO: TRAILING SLASH AND HTTP(S)
  jsonlite::stream_out(file("../data/hybrid_license_df.json"))
#'
#' ## Dealing with flipped journals
#' 
#' Nature Communication is a prominent example of journals that were
#' flipped from toll-access to full open access during the time of our study.
#' 
#' To catch these journals, we can match our data with the DOAJ journal
#' list. The DOAJ is a registry of fully OA journals.
#' 
doaj <- readr::read_csv("https://doaj.org/csv")
#' There are three columns needed:
#' 
#' The two ISSN columns
#' - `Journal ISSN (print version)`
#' - `Journal EISSN (online version)`
#' 
#' and the year, in which the journal started as fully OA journal
#' 
#' - `First calendar year journal provided online Open Access content`
#' 
#' Let's prepare a look-up table
doaj_lookup <- doaj %>% 
  select(issn_print = `Journal ISSN (print version)`,
         issn_e = `Journal EISSN (online version)`,
         year_flipped = `First calendar year journal provided online Open Access content`) %>%
  # we started our analysis in 2013
  filter(year_flipped > 2012) %>%
  # gathering issns into one column
  tidyr::gather(issn_print, issn_e, key = "issn_type", value = "issn") %>%
  # remove missing values
  filter(!is.na(issn))
#' # check with our hybrid license dataset
hybrid_license_df <- jsonlite::stream_in(file("../data/hybrid_license_df.json")) 
flipped_jns <- hybrid_license_df %>% 
  inner_join(doaj_lookup, by = "issn") %>% 
  filter(year_flipped <= year) %>% 
  select(issn, year)
#' remove flipped journals from hybrid license data set and store into json
hybrid_license_df %>% 
  filter(issn %in% flipped_jns$issn & year %in% flipped_jns$year) %>% 
  anti_join(hybrid_license_df, .) %>%
  jsonlite::stream_out(file("../data/hybrid_license_df.json"))
#' ## Calculating gap indicators
#' 
#' The following indicators will be presented through the dashboard. 
#' 
#' - `publisher_n`: number of complient hybrid oa publishers
#' - `journal_n`: number of complient hybrid oa journals
#'  
#' - `license_ref_n`: number of articles published under the license `license_ref` in `year`
#' - `jn_published`: number of articles a journal (`issn`) published in `year`
#' - `pbl_published`: overall publisher output hybrid oa journals per `year`
#' - `year_all`: all articles published in oa hybrid oa journals per `year`
#'  
#'  First of all, we need to filter those journals that have met our inclusion criteria,
#'  licensing info shared via corssref and payment recorded vai open apcö
#'  
jn_publishers <- jsonlite::stream_in(file("../data/jn_facets_df.json")) %>%
  dplyr::as_data_frame() %>%
  distinct(issn, journal_title, publisher)
hybrid_license_df <- 
  jsonlite::stream_in(file("../data/hybrid_license_df.json")) %>%
  dplyr::as_data_frame() %>%
  inner_join(jn_publishers, by = "issn") %>% 
  distinct() %>%
  select(journal_title, issn, year, license, license_ref_n)
jn_indicators <- jsonlite::stream_in(file("../data/jn_facets_df.json")) %>%
  dplyr::as_data_frame() %>% 
  select(journal_title, publisher, issn, year_published) %>%
  tidyr::unnest() %>%
  select(journal_title, publisher, issn, year = .id, jn_published = V1) %>%
  # left join because most journals don't have license infos for every year in
  # the period 2013 -2018
  left_join(hybrid_license_df, by = c("journal_title" = "journal_title", "year" = "year")) %>%
  # we only wnat to examine compliant journals
  filter(journal_title %in% hybrid_license_df$journal_title) %>%
  # do some reordering
  select(journal_title, publisher, issn = issn.x, year, license, license_ref_n = license_ref_n, jn_published)
#' calculate `year_all`
by_year <- jn_indicators %>%
  # work with unique journal / year combination to calculate the
  # the absolute number by year and publisher
  # calculate over title because of issn variants in the open apc dataset
  distinct(year, journal_title, .keep_all = TRUE) %>%
  group_by(year) %>%
  summarize(year_all = sum(jn_published))
#'calculate `pbl_published`
by_publisher <- jn_indicators %>% 
  distinct(year, journal_title, .keep_all = TRUE) %>%
  group_by(publisher, year) %>%
  summarize(year_publisher_all = sum(jn_published))
#' add indicators
jn_indicators %>% 
  left_join(by_year, by = c("year" = "year")) %>%
  left_join(by_publisher, by = c("year" = "year", "publisher" = "publisher")) %>%
  jsonlite::stream_out(file("../data/hybrid_license_indicators.json"))
#' disambiguate licencing infos
tmp <- jsonlite::stream_in(file("../data/hybrid_license_indicators.json"))
tmp_ <- tmp %>% 
  mutate(license = gsub("\\/$", "", license)) %>%
  mutate(license = gsub("https", "http", license)) %>%
  distinct(journal_title, publisher, year, license, .keep_all = TRUE) %>%
  group_by(journal_title, publisher, issn, year, license, jn_published, year_all, year_publisher_all) %>%
  summarise(license_ref_n = sum(license_ref_n))
jsonlite::stream_out(tmp_, file("../data/hybrid_license_indicators.json"))
#' ## csv export
#' 
#' readr::read_csv() is much faster that streaming json, 
#' so we better store data to re-used in the dashboard in csv files
jsonlite::stream_in(file("../data/hybrid_license_indicators.json")) %>%
  readr::write_csv("../data/hybrid_license_indicators.csv")
