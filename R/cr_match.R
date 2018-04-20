#' evaluate coverage oa / pub volumen
library(tidyverse)
library(jsonlite)
#' full data set
license_df <- jsonlite::stream_in(file("../data/hybrid_license_md.json")) %>%
  as_data_frame() %>%
  select(-title,-`clinical-trial-number`, -subtitle, -archive, -abstract, -archive_ , -NA.)
#' get duplicate dois
license_df %>% 
  select(DOI, container.title, publisher) %>% 
  group_by(DOI) %>% 
  filter(n() > 1)
#' which journals and publishers are affected
license_df %>% 
  select(DOI, container.title, publisher) %>% 
  group_by(DOI) %>% 
  filter(n() > 1) %>% 
  ungroup() %>% 
  count(container.title, publisher) %>% 
  arrange(desc(n))
#' create a tidy dataset
license_df %>%
  select(DOI, ISSN, issued) %>%
  # to year
  mutate_at(vars(issued), funs(lubridate::parse_date_time(., c('y', 'ymd', 'ym')))) %>%
  mutate_at(vars(issued), funs(lubridate::year(.))) %>%
  # issn 
  separate(ISSN, into = c("issn_1", "issn_2", "issn_3"), sep = ",") %>%
  gather(issn_1, issn_2, issn_3, key = "issn_type", value = "issn") %>%
  filter(!is.na(issn)) -> tidy_oahybrid_df
#' add licensing info            
jn_all <- jsonlite::stream_in(file("../data/jn_facets_df.json"), simplifyDataFrame = FALSE)
#' tidy import, (we need another back strategy to avoid the follwoing steps)
issn <- map_df(jn_all, "issn")
jn_df <- issn %>%
  mutate(journal_title = map_chr(jn_all, "journal_title")) %>%
  mutate(publisher = map_chr(jn_all, "publisher")) %>%
  mutate(year_published = map(jn_all, c("year_published"))) %>%
  mutate(license_refs = map(jn_all, c("license_refs"))) %>%
  mutate(license_refs = map(license_refs, bind_rows)) %>%
  gather(issn, issn.1, issn.2, issn.3, key = "issn_type", value = "issn") %>%
  filter(!is.na(issn))
jn_df %>%
  mutate(year_published = map(year_published, bind_rows)) -> jn_df
#' load doi set
dois <- jsonlite::stream_in(file("../data/hybrid_license_dois.json"), simplifyDataFrame = FALSE)
map_df(dois, "issn") %>%
  mutate(doi_oa = map(dois, "dois")) %>%
  mutate(license = map_chr(dois, "license")) %>% 
  # issn 
  gather(issn, issn.1, issn.2, issn.3, key = "issn_type", value = "issn") %>% 
  filter(!is.na(issn)) -> dois_df
#' join article datasets
tmp <- inner_join(dois_df, jn_df, by = c("issn" = "issn")) %>% 
  distinct(journal_title, publisher, license, .keep_all = TRUE)

hybrid_oa_df <- tmp %>% 
  select(1:2, journal_title, publisher, year_published) %>% 
  # remove delayed licenses 
  filter(map(doi_oa, length) > 0) %>%
  unnest(doi_oa, .preserve = year_published) %>%
  distinct(doi_oa, .keep_all = TRUE) %>% 
  left_join(tidy_oahybrid_df, by = c("doi_oa" = "DOI"))
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
  # we started our analysis in 2013
  filter(year_flipped > 2012) %>%
  # gathering issns into one column
  tidyr::gather(issn_print, issn_e, key = "issn_type", value = "issn") %>%
  # remove missing values
  filter(!is.na(issn))
#' # check with our hybrid license dataset
hybrid_oa_df %>% 
  inner_join(doaj_lookup, by = "issn") %>% 
  filter(year_flipped <= issued) -> flipped_jns
# export 
select(flipped_jns, -year_published) %>%
  readr::write_csv("../data/flipped_jns_doaj.csv")
#' remove flipped journals from hybrid license data set and store into json
hybrid_oa_df %>% 
  filter(!doi_oa %in% flipped_jns$doi_oa) %>%
  # manually remove Copernicus GmbH, which is a fully oa publisher
  filter(!publisher %in% "Copernicus GmbH") %>%
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
#' export and exclude them
readr::write_csv(prob_flipped, "../data/flipped_jns.csv")
anti_join(indicator_df, prob_flipped,  by = c("journal_title", "publisher", "year")) -> indicator_df
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
  # make sure dois are lower case
  mutate(doi_oa = tolower(doi_oa)) %>%
  distinct(doi_oa, .keep_all = TRUE) %>%
  # issn not needed
  select(-issn_type, -issn, -year_published) %>%
  left_join(indicator_df, by = c("journal_title", "publisher", "license", "issued" = "year"))

#' ### Hybrid journal output vs what was actually sponsored by academic institutions
#'  Get Open APC data dump, and distinguish between individual hybrid and offsetting
o_apc <- readr::read_csv("../data/oapc_hybrid.csv") %>%
  mutate(hybrid_type = ifelse(!is.na(euro), "Open APC (Hybrid)", "Open APC (Offsetting)"))
#' Include country information, which are available via Open APC OLAP server: 
#' <https://github.com/OpenAPC/openapc-olap/blob/master/static/institutions.csv>
country_apc <- readr::read_csv("https://raw.githubusercontent.com/OpenAPC/openapc-olap/master/static/institutions.csv") %>%
  select(institution, country)
countries <- readr::read_csv("https://raw.githubusercontent.com/OpenAPC/openapc-olap/master/static/institutions_offsetting.csv") %>%
  bind_rows(country_apc) %>%
  distinct() %>% 
  mutate(country_name = countrycode::countrycode(country, "iso3c", "country.name"))
#' merge with open apc dataset
#' 
o_apc <- o_apc %>%
  left_join(countries, by = "institution") %>%
  filter(!publisher %in% "Copernicus GmbH")
# export with country infos
readr::write_csv(o_apc, "../data/oapc_hybrid.csv")

o_apc <- o_apc %>%
  # make sure dois are lowercase
  mutate(doi = tolower(doi)) %>%
  # select columns needed
  select(1:4, 19:21)

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
  select(3:6, issued, 7:9, yearly_all, 11:15) -> my_data

#' backup licensing data set
readr::write_csv(my_data, "../data/hybrid_publications.csv")

#' oa stats for springer
my_data %>% 
  filter(publisher == "Springer Nature") %>%
  group_by(issued, license, yearly_publisher_volume) %>%
  summarise(n = n_distinct(doi_oa)) %>%
  mutate(prop = n / yearly_publisher_volume) %>%
  ggplot(aes(issued, prop, fill = license)) + 
  geom_bar(stat = "identity")
  