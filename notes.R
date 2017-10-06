#+ setup, include=FALSE
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  warning = FALSE,
  message = FALSE
)
#' ## What's published in hybrid journals?
#'
#' ### How to retrieve a list of hybrid journals?
#'
#' To my knowledge, there's no comprehensive list of hybrid OA journals. However, a list of
#' hybrid OA journals can be compiled using the Open APC dataset curated by the
#' [Open APC Initiative](github.com/openapc/openapc-de) initiative. This initiative collects
#'  and shares institutional spending information for open access publication fees, 
#'  including those spent for publication in hybrid journals.
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
#' by publishers (top 10)
o_apc %>%
  mutate(publisher = forcats::fct_lump(publisher, n = 10)) %>%
  count(publisher) %>%
  mutate(prop = n / sum(n))
#'
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
jn_facets <- rcrossref::cr_works(
  filter = c(issn = "0907-4449", 
             from_pub_date = "2013-01-01", 
             until_pub_date = "2013-12-31",
             type = "journal-article"),
  facet = TRUE
)

#' There are two helpful facets, `license` for getting license infos and
#' `type-name` for the number of published articles facetted by type
#'
#'
jn_facets$facets$license
jn_facets$facets$`type-name`
#'
#' Relevant facets are also 
jn_facets$facets$`publisher-name`
jn_facets$facets$`container-title`
#' In the first step, get a summary table of articles funded per journal and year.
#' We only want to examine the four-year period 2013 - 2016
hybrid_jn <- o_apc %>%
  group_by(period, issn) %>%
  summarise(n = n(), euro = sum(euro, na.rm = TRUE)) %>% 
  ungroup() %>% 
  tidyr::complete(period, issn, fill = list(n = 0, euro = 0)) %>% 
  filter(period %in% 2013:2016)
hybrid_jn
#' Now let's fetch facet infos (licenses and work published) for every journal 
#'
cr_hybrid <-
  purrr::map2(
   hybrid_jn$period,
   hybrid_jn$issn,
    .f = plyr::failwith(f = function(x, y) {
      start_date <- paste0(x, "-01-01")
      end_date <- paste0(x, "-12-31")
      tmp <- rcrossref::cr_works(
        filter = c(
          issn = y,
          from_pub_date = start_date, until_pub_date = end_date, 
          type = "journal-article"),
        facet = TRUE
      )
      if(is.null(tmp$facets)) {
        NULL
      } else {
      cbind(
        licence_ref = tmp$facets$license$.id,
        licence_ref_n = tmp$facets$license$V1,
        year = x,
        issn = y,
        all_published = tmp$facets$published$V1,
        publisher = tmp$facets$`publisher-name`$.id[1],
        journal = tmp$facets$`container-title`$.id[1]
      )
      }
    })
  )
cr_hybrid_df <- purrr::map_df(cr_hybrid, dplyr::as_data_frame)
#' Backup
readr::write_csv(cr_hybrid_df, "data/cr_hybrid_df.csv")

