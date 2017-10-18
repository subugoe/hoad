#' ### Hybrid journal output vs what was actually sponsored by academic institutions
#' 
#' load indicator set
cr_df <- readr::read_csv("data/cr_hybrid_df_indicators.csv")
#' interesting values are
#' 
#'- licence_ref_n : number of articles for a licence in a year
#'- 
#'- year: year published
#'- licence_ref: license
#' 
#' Open APC
u <-
  "https://raw.githubusercontent.com/OpenAPC/openapc-de/master/data/apc_de.csv"
o_apc <- readr::read_csv(u) %>%
  filter(is_hybrid == TRUE)
#' Some summary statistics:
#'
#' We also would like to add data from offsetting aggrements, which is also collected
#' Open APC initiative, but does not include pricing information.
#' 
o_offset <- readr::read_csv("https://raw.githubusercontent.com/OpenAPC/openapc-de/master/data/offsetting/offsetting.csv")
#' Merge with Open APC dataset
o_apc <- o_offset %>% 
  mutate(euro = as.integer(euro)) %>% 
  bind_rows(o_apc) 
#' Include country information, which are available via Open APC OLAP server: 
#' <https://github.com/OpenAPC/openapc-olap/blob/master/static/institutions.csv>
country_apc <- readr::read_csv("https://raw.githubusercontent.com/OpenAPC/openapc-olap/master/static/institutions.csv") %>%
  select(institution, country)
countries <- readr::read_csv("https://raw.githubusercontent.com/OpenAPC/openapc-olap/master/static/institutions_offsetting.csv") %>%
  bind_rows(country_apc) %>%
  distinct() %>% 
  mutate(country = gsub("NDL", "NLD", country)) %>%
  mutate(country_name = countrycode::countrycode(country, "iso3c", "country.name"))
#' merge with open apc dataset
#' 
o_apc <- o_apc %>%
  left_join(countries, by = "institution")
#' create summary table which we want to merge into our indicators dataset 
o_apc_country <- o_apc %>%
  group_by(country, issn, period) %>%
  summarize(oapc_n_country = n()) %>%
  filter(period %in% c("2013", "2014", "2015","2016"))
o_apc_ind <- o_apc_country %>%
  group_by(period, issn) %>%
  summarize(oapc_n_year = sum(oapc_n_country)) %>%
  right_join(o_apc_country, by = c("issn", "period"))
#' merge with main indicator data frame
o_apc_df <- rio::import("data/cr_hybrid_df_indicators.csv") %>%
  filter(hybrid_license == TRUE) %>%
  # a quick and dirty appraoch to deal with journals that changed issn within a year
  distinct(journal, year, licence_ref, .keep_all = TRUE) %>%
  select(journal, year, issn) %>% 
  left_join(o_apc_ind, by = c("issn" = "issn", "year" = "period")) %>%
  distinct() %>%
  mutate(continent = countrycode::countrycode(country, "iso3c", "continent")) %>%
  readr::write_csv("data/oapc_aggregated.csv")
  