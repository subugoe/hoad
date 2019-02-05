#' emails add
library(tidyverse)
emails_df <- readr::read_csv("../data/emails_normalized.csv")
hybrid <- readr::read_csv("../data/hybrid_publications.csv")
hybrid %>%
  left_join(emails_df, by = c("doi_oa" = "doi")) %>%
  readr::write_csv("../data/hybrid_publications.csv")
  
