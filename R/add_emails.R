#' emails add
library(tidyverse)
emails_df <- readr::read_csv("../data/emails_normalized.csv")
hybrid <- readr::read_csv("../data/hybrid_publications.csv") %>%
  select(1:country_name)
hybrid_emails <- hybrid %>%
  left_join(emails_df, by = c("doi_oa" = "doi")) %>%
  distinct(doi_oa, .keep_all = TRUE)
readr::write_csv(hybrid_emails, "../data/hybrid_publications.csv")
  
