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
#' [Open APC Initiative](github.com/openapc/openapc-de) initiative. This initiative collects and shares
#' institutional spending information for open access publication fees, including those spent for publication
#' in hybrid journals.
#'
#' Let's retrieve the most current dataset:
#'
library(dplyr)
# link to dataset
u <-
  "https://raw.githubusercontent.com/OpenAPC/openapc-de/master/data/apc_de.csv"
o_apc <- readr::read_csv(u) %>%
  filter(is_hybrid == TRUE)
#' Some summary statistics:
#'
#' by publishers (top 10)
library(ggplot2)
o_apc %>%
  mutate(publisher = forcats::fct_lump(publisher, n = 10)) %>%
  count(publisher, sort = TRUE) %>%
  ggplot(aes(reorder(publisher, n), n)) +
  geom_bar(stat = "identity") +
  coord_flip()
#'
#' ## How does it relate to the general hybrid output per journal?
#'
#' Crossref Metadata API is used to get both license information and number of articles
#' published per year. The API is accessed via
#' [rOpenSci's rcrossref client](https://github.com/ropensci/rcrossref).
#'
#' Instead of fetching all articles published, we use facet counts.
#'
#' <https://github.com/CrossRef/rest-api-doc/#facet-counts>
#'
jn_facets <- rcrossref::cr_journals(
  "1053-8119",
  filter = c(from_pub_date = "2014-01-01", until_pub_date = "2014-12-31"),
  works = TRUE,
  limit = 0,
  facet = TRUE
)

#' There are two helpful facets, `license` for getting license infos and
#' `type-name` for the number of published articles facetted by type
#'
#'
jn_facets$facets$license

jn_facets$facets$`type-name`
#'
#' In the first step, get a summary table of articles funded per journal and year
hybrid_jn <- o_apc %>%
  group_by(journal_full_title, issn, period) %>%
  summarise(n = n()) %>%
  arrange(desc(n))
hybrid_jn
#' Now let's fetch facet infos (licenses and work published) for every journal and year
#'
cr_hybrid <-
  purrr::map2(
   hybrid_jn$period,
   hybrid_jn$issn,
    .f = plyr::failwith(f = function(x, y) {
      start_date <- paste0(x, "-01-01")
      end_date <- paste0(x, "-12-31")
      tmp <- rcrossref::cr_journals(
        y,
        filter = c(from_pub_date = start_date, until_pub_date = end_date),
        works = TRUE,
        limit = 0,
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
        all_published = tmp$facets$published$V1
      )
      }
    })
  )
cr_hybrid_df <- map_df(cr_hybrid, dplyr::as_data_frame)
#' Backup
readr::write_csv(cr_hybrid_df, "data/cr_hybrid_df.csv")
