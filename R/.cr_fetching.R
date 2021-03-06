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
library(countrycode)
library(jsonlite)
library(rcrossref)
library(furrr)
#' link to dataset
u <-
  "https://raw.githubusercontent.com/OpenAPC/openapc-de/master/data/apc_de.csv"
o_apc <- readr::read_csv(u)
#'
#' We also would like to add data from transformative aggrements, which is also
#' collected by the Open APC initiative.
#' The transformative agreements data-set does not include pricing information.
#'
oa_trans <-
  readr::read_csv(
    "https://github.com/OpenAPC/openapc-de/blob/master/data/transformative_agreements/transformative_agreements.csv?raw=true"
  )
#' Merge with Open APC dataset
o_apc <- oa_trans %>%
  mutate(euro = as.integer(euro)) %>%
  bind_rows(o_apc) %>%
  # start from 2013
  filter(period > 2012) %>%
  # just hybrid oa journals
  filter(is_hybrid == TRUE) %>%
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
  # https://github.com/subugoe/hoad/issues/10
  filter(!journal_full_title == "STEM CELLS Translational Medicine") %>%
  # 6. distinguish between individual hybrid and offsetting
  mutate(hybrid_type = ifelse(!is.na(euro), "Open APC (Hybrid)", "Open APC (TA)"))
#' Include country information
country_apc <- readr::read_csv("https://raw.githubusercontent.com/OpenAPC/openapc-de/master/data/institutions.csv") %>%
  select(institution, country)
countries <- readr::read_csv("https://raw.githubusercontent.com/OpenAPC/openapc-de/master/data/institutions_transformative_agreements.csv") %>%
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
#' the number of articles published per year for the period 2013 - 2019.
#' The API is accessed with [rOpenSci's rcrossref client](https://github.com/ropensci/rcrossref).
#'
#' Instead of fetching all articles published, we use facet counts to keep API usage low
#'
#' <https://github.com/CrossRef/rest-api-doc/#facet-counts>
#'
#' This involves two steps:
#'
#' First, we retrieve journal article volume and corresponding licensing information
#' for the period  2013 - 2019 for all issns per journal in the Open APC dataset.
#'
#' Let's gather the issn's
o_apc %>%
  distinct(
    issn,
    issn_print,
    issn_electronic,
    journal_full_title,
    publisher
  ) %>%
  gather(issn,
    issn_print,
    issn_electronic,
    key = "issn_type",
    value = "issn"
  ) %>%
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
#' create a data frame with distinct journal_title and publisher names
distinct_combs <- o_apc_issn %>%
  distinct(publisher, journal_full_title)
#' create multiple issn filters
issns_list <-
  purrr::map2(distinct_combs$publisher, distinct_combs$journal_full_title, function(x, y) {
    issns <- o_apc_issn %>%
      filter(publisher == x, journal_full_title == y) %>%
      .$issn
    names(issns) <- rep("issn", length(issns))
    issns
  })
#' search crossref
jn_facets <- purrr::map(issns_list, .f = purrr::safely(function(x) {
  tt <- rcrossref::cr_works(
    filter = c(
      x,
      from_pub_date = "2013-01-01",
      until_pub_date = "2020-12-31",
      type = "journal-article"
    ),
    # being explicit about facets improves API performance!
    facet = "license:*,published:*,container-title:*,publisher-name:*",
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
jn_facets_df <- jsonlite::stream_in(file("../data/jn_facets_df.json"))
#' Second, filter out open licenses and check:
#' now add indication to the dataset
hybrid_licenses <- jn_facets_df %>%
  select(journal_title, publisher, license_refs) %>%
  tidyr::unnest(cols = c(license_refs)) %>%
  mutate(license_ref = tolower(.id)) %>%
  select(-.id) %>%
  mutate(hybrid_license = ifelse(grepl(
    paste(license_patterns$url, collapse = "|"),
    license_ref
  ), TRUE, FALSE)) %>%
  filter(hybrid_license == TRUE) %>%
  left_join(jn_facets_df, by = c("journal_title" = "journal_title", "publisher" = "publisher"))
#' We now know, whether and which open licenses were used by the journal in the
#' period 2013:2019. As a next step we want to validate that these
#' licenses were not issued for delayed open access articles by
#' additionally using  the self-explanatory filter `license.url` and
#'  `license.delay`. We also obtain parsed metadata for these hybrid open
#'  access articles stored as list-column. metadata fields we pare are
#'  defined in `cr_md_fields`
cr_md_fields <- c(
  "URL", "member", "created", "license",
  "ISSN", "container-title", "issued", "approved",
  "indexed", "accepted", "DOI", "funder", "published-print",
  "subject", "published-online", "link", "type", "publisher",
  "issn-type", "deposited", "content-created"
)
# parallel wih furrr
plan(multisession)
cr_license <- furrr::future_map2(hybrid_licenses$license_ref, hybrid_licenses$issn,
  .f = purrr::safely(function(x, y) {
    u <- x
    issn <- y
    names(issn) <- rep("issn", length(issn))
    tmp <- rcrossref::cr_works(
      filter = c(issn,
        license.url = u,
        license.delay = 0,
        type = "journal-article",
        from_pub_date = "2013-01-01",
        until_pub_date = "2020-12-31"
      ),
      cursor = "*", cursor_max = 5000L,
      limit = 1000L,
      select = cr_md_fields
    )
    tibble::tibble(
      issn = list(issn),
      license = u,
      md = list(tmp$data)
    )
  }), .progress = TRUE
)
#' into one data frame!
#' dump it
cr_license_df <- cr_license %>%
  purrr::map_df("result")
#' all, results into a large file, which won't be tracked with GIT
dplyr::bind_rows(cr_license_df$md) %>%
  jsonlite::stream_out(file("../data/hybrid_license_md.json"))
#' only DOIs and how we retrieved them
purrr::map(cr_license_df$md, "doi") %>%
  tibble(dois = ., issn = cr_license_df$issn, license = cr_license_df$license) %>%
  jsonlite::stream_out(file("../data/hybrid_license_dois.json"))
