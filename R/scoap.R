# scoap / hybrid
# obtain records from scoap3 repository
library(tidyverse)
library(oai)
scoap_records <- list_records(url = "https://repo.scoap3.org/oai2d")
scoap_records %>% 
  select(identifier, identifier.1, identifier.2, identifier.3, identifier.4) -> scoap_short
scoap_short %>%
  gather(2:5, key = "id_type", value = "id") %>%
  filter(grepl("doi:", id)) %>%
  mutate(doi = tolower(id)) %>%
  mutate(doi = gsub("doi:", "", doi)) -> scoap_doi
# match with hybrid oa data set and export
hybrid_oa <- readr::read_csv("../data/hybrid_publications.csv")
hybrid_oa %>%
  mutate(hybrid_type = ifelse(doi_oa %in% scoap_doi$doi, "SCOAP", hybrid_type)) %>%
  write_csv("../data/hybrid_publications.csv")
