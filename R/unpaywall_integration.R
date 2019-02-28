#' bq unpaywall dump
#'
#' connect to google bg where I imported the jsonl Unpaywall dump
library(DBI)
library(bigrquery)
library(tidyverse)
library(jsonlite)
con <- dbConnect(bigrquery::bigquery(),
                 project = "api-project-764811344545",
                 dataset = "oadoi_full")
#' test connection
oadoi <- tbl(con, "mongo_13_sep_18")
#' my bq query
sql_unnested <-
  "SELECT doi, evidence, publisher, journal_name, journal_issns, year, is_best, license, host_type
FROM `oadoi_full.mongo_13_sep_18`, UNNEST(oa_locations)
WHERE `journal_is_in_doaj`=false AND data_standard=2 AND EXISTS (
SELECT evidence FROM UNNEST(oa_locations)
WHERE evidence LIKE '%license%'
)
"
#' call bq
dbGetQuery(con, sql_unnested) -> my_license
#' backup
# write_csv(my_license, "../data/license_13_18_unpaywall.csv")
#' prepare matching with hybrid oa dashboard dataset
my_license %>%
  separate(journal_issns, c("issn_1", "issn_2", "issn_3", "issn_4"), sep =
             ",") %>%
  gather(issn_1:issn_4, key = "issn_position", value = "issn") %>%
  filter(!is.na(issn)) -> oadoi_issns
#' get issn variants from crossref
hybrid_issn <-
  jsonlite::stream_in(
    file("../data/jn_facets_df.json"),
    simplifyDataFrame = FALSE
  )
issn <- map_df(hybrid_issn, "issn")
jn_df <- issn %>%
  mutate(journal_title = map_chr(hybrid_issn, "journal_title")) %>%
  mutate(publisher = map_chr(hybrid_issn, "publisher")) %>%
  gather(issn, issn.1, issn.2, issn.3, key = "issn_type", value = "issn") %>%
  filter(!is.na(issn))
#' only journals from unpaywall that are in our sample as well
oadoi_issns %>%
  filter(issn %in% jn_df$issn) -> hybrid_oadoi_sub
#' merge with dashboard dataset
hybrid_dash <- readr::read_csv("../data/hybrid_publications.csv")
hybrid_oadoi_sub %>%
  inner_join(jn_df, by = "issn") %>%
  mutate(publisher = publisher.y) %>%
  mutate(publisher = ifelse(
    grepl(
      "Springer",
      publisher,
      fixed = FALSE,
      ignore.case = TRUE
    ),
    "Springer Nature",
    publisher
  )) %>%
  select(-publisher.x,-publisher.y,-journal_name) %>%
  # only interested in license
  filter(grepl("license", evidence, fixed = FALSE)) %>%
  # only interested in same journal and and publisher sample
  filter(journal_title %in% hybrid_dash$journal_title,
         publisher %in% hybrid_dash$publisher) %>%
  # tag articles we already have
  mutate(in_dashbaord = ifelse(doi %in% hybrid_dash$doi_oa, TRUE, FALSE)) %>%
  filter(!evidence == "open (via crossref license, author manuscript)") %>%
  group_by(year, publisher, in_dashbaord, journal_title) %>%
  summarise(articles = n_distinct(doi)) %>%
  ungroup() -> oadoi_indicators
#' add indicator, in unpaywall, but not in our sample per journal and year,
#' to our hybrid dashboard dataset
oadoi_indicators %>%
  filter(in_dashbaord == FALSE) %>%
  select(-in_dashbaord) %>%
  rename(jn_y_unpaywall_others = articles) %>%
  left_join(hybrid_dash,
            .,
            by = c("journal_title", "publisher", "issued" = "year")) -> dash_new
#' export
write_csv(dash_new, "../data/hybrid_publications.csv")
