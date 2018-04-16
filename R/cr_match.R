#' evaluate coverage oa / pub volumen

#' full data set
license_df <- jsonlite::stream_in(file("~/Downloads/hybrid_license_md.json")) %>%
  as_data_frame() %>%
  select(-title,-`clinical-trial-number`, -subtitle, -archive, -abstract, -archive_ , -NA.)
#' get duplicate dois
license_df %>% 
  select(DOI, container.title, publisher) %>% 
  group_by(DOI) %>% 
  filter(n() > 1)
#' which jorunals and publishers are affected
license_df %>% 
  select(DOI, container.title, publisher) %>% 
  group_by(DOI) %>% 
  filter(n() > 1) %>% 
  ungroup() %>% 
  count(container.title, publisher) %>% 
  arrange(desc(n))
#' create a tidy dataset
license_df %>%
  select(DOI, ISSN, issued, li) %>%
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
  gather(issn, issn.1, issn.2, issn.3, key = "issn_type", value = "issn")
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
#' analytics
#' yearly journal article volume
yearly_volume <- tmp %>%
  select(journal_title, publisher, year_published) %>%
  distinct() %>% 
  unnest(year_published) %>%
  select(1:3, year = .id, yearly_jn_volume = V1) %>%
  mutate(year = lubridate::parse_date_time(year, 'y')) %>%
  mutate(year = lubridate::year(year))
#' create hybrid oa data set
hybrid_oa_df <- tmp %>% 
  select(1:2, journal_title, publisher) %>% 
  # remove delayed licenses 
  filter(map(doi_oa, length) > 0) %>%
  unnest(doi_oa) %>%
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
  filter(year_flipped <= issued) %>% 
  select(issn, issued) -> flipped_jns
#' remove flipped journals from hybrid license data set and store into json
hybrid_oa_df %>% 
  filter(issn %in% flipped_jns$issn & issued %in% flipped_jns$issued) %>% 
  anti_join(hybrid_oa_df, .) -> hybrid_oa_df
#' yearly license_uri volume -> indicator set
hybrid_oa_df %>%
  group_by(journal_title, publisher, license, issued) %>%
  summarize(license_ref_n = n_distinct(doi_oa)) %>% 
  left_join(yearly_volume, by = c("journal_title", "publisher", "issued" = "year")) -> indicator_df
#' get journals that are probably flipped, defined as prop > 0.95 in at least two years
indicator_df %>% 
  group_by(journal_title, publisher, issued, yearly_jn_volume) %>% 
  summarise(n_year = sum(license_ref_n)) %>% 
  mutate(prop = n_year / yearly_jn_volume) %>% 
  filter(prop > 0.95) %>% 
  ungroup() %>%
  group_by(journal_title, publisher) %>%
  filter(n() > 1) -> prob_flipped
