# scoap / hybrid
# obtain records from scoap3 repository
library(tidyverse)
library(oai)
scoap_records <- list_records(url = "https://repo.scoap3.org/oai2d", prefix = "marc21")
tt <- scoap_records %>% 
  select(identifier, datestamp, datafield) %>%
  mutate(doi = tolower(gsub("DOI", "", datafield)))
# backup
write_csv(tt, "../data/scoap_oai_dois.csv")
# match with hybrid oa data set and export
hybrid_oa <- readr::read_csv("../data/hybrid_publications.csv")
hybrid_oa %>%
  mutate(hybrid_type = ifelse(doi_oa %in% tt$doi, "SCOAP", hybrid_type)) %>%
  write_csv("../data/hybrid_publications.csv")
