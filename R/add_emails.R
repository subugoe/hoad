#' emails add
library(tidyverse)
emails_df <- readr::read_csv("../data/emails_normalized.csv") %>%
  distinct(doi, .keep_all = TRUE)
hybrid <- readr::read_csv("../data/hybrid_publications.csv") %>%
  select(-host, -subdomain, -domain, -suffix, -tld)
hybrid %>%
  left_join(emails_df, by = c("doi_oa" = "doi")) %>%
  readr::write_csv("../data/hybrid_publications.csv")
