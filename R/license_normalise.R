#' Normalize open content licenses
library(tidyverse)
hybrid <- readr::read_csv("data/hybrid_publications.csv")
hybrid %>%
  mutate(license = gsub("http://creativecommons.org/licenses/", "cc-", license)) %>%
  mutate(license = gsub("/3.0*", "", license)) %>%
  mutate(license = gsub("/4.0", "", license)) %>%
  mutate(license = gsub("/2.0*", "", license)) %>%
  mutate(license = gsub("/uk/legalcode", "", license)) %>%
  mutate(license = gsub("/igo", "", license)) %>%
  mutate(license = gsub("/legalcode", "", license)) %>%
  mutate(
    license = ifelse(!grepl("cc-", license),
      "Publisher specific",
      license
    )
  ) %>%
  mutate(license = toupper(license)) %>%
  mutate(license = gsub("CC-BY-NCND", "CC-BY-NC-ND", license)) %>% 
  mutate(license = forcats::fct_lump(license, n = 5)) %>%
  mutate(license = tolower(license)) -> hybrid_ocl
# test
hybrid_ocl %>%
  count(license, sort = TRUE)
# export
hybrid_ocl %>%
  write_csv("data/hybrid_publications.csv")
  
  
