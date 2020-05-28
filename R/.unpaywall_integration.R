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
oadoi <- tbl(con, "mongo_export_upwNov19_13_19")
#' my bq query
sql_unnested <-
  "SELECT doi, evidence, publisher, journal_name, journal_issns, year, is_best, license, host_type
FROM `mongo_export_upwNov19_13_19` , UNNEST(oa_locations)
WHERE `journal_is_in_doaj`= false AND data_standard=2 AND EXISTS (
SELECT evidence FROM UNNEST(oa_locations)
WHERE evidence = 'open (via crossref license)' OR evidence = 'open (via page says license)')
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
jn_all <- jsonlite::stream_in(file("../data/jn_facets_df.json"))
jn_df <- jn_all %>%
  select(issn, publisher, journal_title) %>%
  unnest(issn) %>%
  filter(!is.na(issn)) %>%
  mutate(publisher = ifelse(grepl("Springer", publisher, fixed = FALSE, ignore.case = TRUE),
                            "Springer Nature", publisher))
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
  rename(jn_y_unpaywall_others = articles) -> oadoi_others

left_join(hybrid_dash, oadoi_others,
            by = c("journal_title" = "journal_title", "publisher" = "publisher", "issued" = "year")) -> dash_new
unpaywall_df <- dash_new %>%
  rename(year = issued) %>%
  group_by(year, journal_title, publisher, jn_y_unpaywall_others) %>%
  summarise(n = n_distinct(doi_oa)) %>%
  gather(n, jn_y_unpaywall_others, key = "source", value = "articles") %>%
  ungroup() %>%
  group_by(year,journal_title, publisher, source) %>%
  summarise(articles = sum(articles, na.rm = TRUE)) %>%
  mutate(
    source = ifelse(
      source == "n",
      "Crossref immediate license",
      "Other license information\n(Unpaywall)"
    )
  )
#' export
readr::write_csv(unpaywall_df, "../data/unpaywall_df.csv")
