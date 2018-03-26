#' filter out journals that were flipped and are not in DOAJ, 
#' or were our data aggregation does not work properly
library(tidyverse)
hybrid_df <- readr::read_csv("../data/hybrid_license_indicators.csv")
hybrid_df %>% 
  distinct() %>%
  group_by(journal_title, year, jn_published) %>% 
  summarise(n = sum(license_ref_n, na.rm = TRUE)) %>% 
  mutate(prop = n / jn_published) %>% 
  filter(prop >= 1, year <= 2017) -> flipped_jns
#' backup
readr::write_csv(flipped_jns, "../data/flipped_jns.csv")
#' filter out
hybrid_df %>% 
  filter(!journal_title %in% flipped_jns$journal_title) %>%
  jsonlite::stream_out(file("../data/hybrid_license_indicators.json"))
#' readr::read_csv() is much faster that streaming json, 
#' so we better store data to re-used in the dashboard in csv files
jsonlite::stream_in(file("../data/hybrid_license_indicators.json")) %>%
  readr::write_csv("../data/hybrid_license_indicators.csv")
