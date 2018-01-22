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
  mutate(country = gsub("NDL", "NLD", country)) %>%
  mutate(country_name = countrycode::countrycode(country, "iso3c", "country.name"))
#' merge with open apc dataset
#' 
o_apc <- o_apc %>%
  left_join(countries, by = "institution")
#' merge with main indicator data frame
jn_publishers <-  jsonlite::stream_in(file("../data/hybrid_license_indicators.json")) %>%
  dplyr::as_data_frame() %>%
  distinct(issn, journal_title, publisher)
#' create summary table which we want to merge into our indicators dataset 
o_apc_country <- o_apc %>%
  left_join(jn_publishers, by = "issn") %>%
  group_by(country, journal_title, period, hybrid_type) %>%
  summarize(oapc_n_country = n()) %>%
  filter(period %in% c("2013", "2014", "2015","2016", "2017"))
o_apc_ind <- o_apc_country %>%
  group_by(period, journal_title) %>%
  summarize(oapc_n_year = sum(oapc_n_country)) %>%
  right_join(o_apc_country, by = c("journal_title", "period")) %>%
  mutate(continent = countrycode::countrycode(country, "iso3c", "continent"))
jsonlite::stream_out(o_apc_ind, file("../data/oapc_aggregated.json"))
#' ## csv export
#' 
#' readr::read_csv() is much faster that streaming json, 
#' so we better store data to re-used in the dashboard in csv files
jsonlite::stream_in(file("../data/oapc_aggregated.json")) %>%
  readr::write_csv("../data/oapc_aggregated.csv")

