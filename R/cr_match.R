library(tidyverse)
library(jsonlite)
#' full data set
license_df <- jsonlite::stream_in(file("../data/hybrid_license_md.json")) %>%
  as_data_frame() %>%
  mutate(publisher = ifelse(grepl("Springer", publisher, fixed = FALSE, ignore.case = TRUE),
                            "Springer Nature", publisher)) 
#' get duplicate dois
license_df %>% 
  select(doi, container.title, publisher) %>% 
  group_by(doi) %>% 
  filter(n() > 1)
#' which journals and publishers are affected
license_df %>% 
  select(doi, container.title, publisher) %>% 
  group_by(doi) %>% 
  filter(n() > 1) %>% 
  ungroup() %>% 
  count(container.title, publisher) %>% 
  arrange(desc(n))
#' create a tidy dataset
license_df %>%
  select(doi, issn, issued) %>%
  # to year
  mutate(issued = lubridate::parse_date_time(issued, c('y', 'ymd', 'ym'))) %>%
  mutate(issued = lubridate::year(issued)) %>%
  # issn 
  separate(issn, into = c("issn_1", "issn_2", "issn_3"), sep = ",") %>%
  gather(issn_1, issn_2, issn_3, key = "issn_type", value = "issn") %>%
  filter(!is.na(issn)) -> tidy_oahybrid_df
#' add licensing info            
jn_all <- jsonlite::stream_in(file("../data/jn_facets_df.json"))
jn_df <- jn_all %>%
  unnest(issn, .preserve = year_published) %>%
  filter(!is.na(issn)) %>%
  mutate(publisher = ifelse(grepl("Springer", publisher, fixed = FALSE, ignore.case = TRUE),
                            "Springer Nature", publisher))
#' load doi set
dois <- jsonlite::stream_in(file("../data/hybrid_license_dois.json"))
dois %>%
  unnest(issn, .preserve = dois) %>%
  filter(!is.na(issn))  -> dois_df
#' join article datasets
tmp <- inner_join(dois_df, jn_df, by = c("issn" = "issn")) %>% 
  distinct(journal_title, publisher, license, .keep_all = TRUE)

hybrid_oa_df <- tmp %>% 
  select(-issn) %>% 
  # remove delayed licenses 
  filter(map(dois, length) > 0) %>%
  unnest(dois, .preserve = year_published) %>%
  distinct(dois, .keep_all = TRUE) %>% 
  left_join(tidy_oahybrid_df, by = c("dois" = "doi"))
#' check for DOAJ
#' #'
#' ## Dealing with flipped journals
#' 
#' Nature Communication is a prominent example of journals that were
#' flipped from toll-access to full open access during the time of our study.
#' 
#' To catch these journals, we can match our data with the DOAJ journal
#' list. The DOAJ is a registry of fully OA journals.
#' 
doaj <- readr::read_csv("https://doaj.org/csv")
#' There are three columns needed:
#' 
#' The two ISSN columns
#' - `Journal ISSN (print version)`
#' - `Journal EISSN (online version)`
#' 
#' and the year, in which the journal started as fully OA journal
#' 
#' - `First calendar year journal provided online Open Access content`
#' 
#' Let's prepare a look-up table
doaj_lookup <- doaj %>% 
  select(issn_print = `Journal ISSN (print version)`,
         issn_e = `Journal EISSN (online version)`,
         year_flipped = `First calendar year journal provided online Open Access content`) %>%
  # gathering issns into one column
  tidyr::gather(issn_print, issn_e, key = "issn_type", value = "issn") %>%
  # remove missing values
  filter(!is.na(issn))
#' # Include ISOS GOLD OA list to include ISSN-L information.
#' Rimmert C, Bruns A, Lenke C, Taubert NC. (2017): 
#' ISSN-Matching of Gold OA Journals (ISSN-GOLD-OA) 2.0. Bielefeld University. 
#' https://doi.org/10.4119/unibi/2913654.
isos <- readr::read_csv("https://pub.uni-bielefeld.de/download/2913654/2913655/ISSN_GOLD-OA_2.0.csv") %>%
  select(1:2)
doaj_lookup %>% 
  left_join(isos, by = c("issn" = "ISSN")) %>%
  tidyr::gather(issn, ISSN_L, key = "issn_type", value = "issn") -> doaj_lookup
#' # check with our hybrid license dataset
hybrid_oa_df %>% 
  inner_join(doaj_lookup, by = c("issn" = "issn")) %>% 
  filter(year_flipped <= issued) -> flipped_jns
# export 
flipped_jns %>%
  select(-year_published) %>%
  distinct(dois,.keep_all = TRUE) %>%
  readr::write_csv("../data/flipped_jns_doaj.csv")
#' remove flipped journals from hybrid license data set and store into json
hybrid_oa_df %>% 
  rename(doi_oa = dois) %>%
  filter(!doi_oa %in% flipped_jns$dois) %>%
  # clean license URIS
  mutate(license = gsub("\\/$", "", license)) %>%
  mutate(license = gsub("https", "http", license)) -> hybrid_oa_df
#' yearly license_uri volume -> indicator set
hybrid_oa_df %>%
  group_by(journal_title, publisher, license, issued) %>%
  summarize(license_ref_n = n_distinct(doi_oa)) %>% 
  ungroup() -> indicator_df
# yearly journal volume
hybrid_oa_df %>%
  select(journal_title, publisher, year_published) %>%
  distinct() %>%
  unnest(year_published) %>%
  select(1:3, year = .id, yearly_jn_volume = V1) %>%
  mutate(year = lubridate::parse_date_time(year, 'y')) %>%
  mutate(year = lubridate::year(year)) %>%
  left_join(indicator_df, by = c("journal_title", "publisher", "year" = "issued")) -> indicator_df
#' yearly 
#' get journals that are probably flipped, defined as prop > 0.95 in at least two years
indicator_df %>% 
  group_by(journal_title, publisher, year, yearly_jn_volume) %>% 
  summarise(n_year = sum(license_ref_n)) %>% 
  mutate(prop = n_year / yearly_jn_volume) %>% 
  filter(prop > 0.95) %>% 
  ungroup() %>%
  group_by(journal_title, publisher) %>%
  filter(n() > 1) -> prob_flipped
#' also check with those jns found by mathias et al 
#' 10.5281/zenodo.2553582
rv_flip <- readr::read_csv("https://zenodo.org/record/2553582/files/reverse_flips_dataset.csv?download=1")
indicator_df %>%
  inner_join(rv_flip, by = c("journal_title" = "journal_name")) %>% 
  filter(year < year_reverse_flipped) -> rev_flip_list
#' export and exclude them
readr::write_csv(prob_flipped, "../data/flipped_jns.csv")
anti_join(indicator_df, prob_flipped,  by = c("journal_title", "publisher", "year")) %>%
  anti_join(rev_flip_list, by = c("journal_title", "publisher", "year")) -> indicator_df
#' calculate publishers article volume and add this info to the dataset
indicator_df %>% 
  distinct(journal_title, publisher, year,.keep_all = TRUE) %>%
  group_by(publisher, year) %>%
  summarise(yearly_publisher_volume = sum(yearly_jn_volume)) -> year_publisher
# merge
left_join(indicator_df, year_publisher, by = c("publisher", "year")) -> indicator_df
#' backup 
readr::write_csv(indicator_df, "../data/indicator.csv")
#' ### match with open apc dataset
hybrid_dois <- hybrid_oa_df %>%
  # remove flipped journals 
  anti_join(prob_flipped,  by = c("journal_title", "publisher", "issued" = "year")) %>%
  anti_join(rev_flip_list, by = c("journal_title", "publisher","issued" = "year")) %>%
  # make sure dois are lower case
  mutate(doi_oa = tolower(doi_oa)) %>%
  distinct(doi_oa, .keep_all = TRUE) %>%
  # issn not needed
  select(-issn_type, -issn, -year_published) %>%
  left_join(indicator_df, by = c("journal_title", "publisher", "license", "issued" = "year"))

#' ### Hybrid journal output vs what was actually sponsored by academic institutions
#'  Get Open APC data dump, and distinguish between individual hybrid and offsetting
o_apc <- readr::read_csv("../data/oapc_hybrid.csv") %>%
  # make sure dois are lowercase
  mutate(doi = tolower(doi)) %>%
  # select columns needed
  select(1:4, hybrid_type, country, country_name)

#' merge with hybrid_dois data set
hybrid_dois %>%
  left_join(o_apc, by = c("doi_oa" = "doi")) -> my_data
#' include yearly volumes 
my_data %>% 
  distinct(issued, publisher, yearly_publisher_volume) %>% 
  group_by(issued) %>% 
  summarise(yearly_all = sum(yearly_publisher_volume)) %>%
  right_join(my_data, by = c("issued")) %>%
  # some sorting of columns
  select(license, 
         journal_title,
         publisher,
         doi_oa,
         issued,
         yearly_jn_volume,
         license_ref_n,
         yearly_publisher_volume,
         yearly_all,
         institution,
         period,
         euro,
         hybrid_type,
         country,
         country_name) -> tt

#' backup licensing data set
readr::write_csv(tt, "../data/hybrid_publications.csv")
