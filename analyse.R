#' ## Summary statistics
my_df <- readr::read_csv("data/cr_hybrid_df.csv") %>%
  filter(!is.na(all_published))
#' by year
by_year <- my_df %>%
  # work with unique journal / year combination to calculate the
  # the absolute number by year and publisher
  distinct(year, journal, .keep_all = TRUE) %>%
  group_by(year) %>%
  summarize(year_all = sum(all_published))
# published by publisher. If there is more than one publisher per year and journal, which is sometimes the case,
# then the publisher that registered most articles for that period gets all,
# 
by_publisher <- my_df %>% 
  distinct(year, journal, .keep_all = TRUE) %>%
  group_by(publisher, year) %>%
  summarize(year_publisher_all = sum(all_published))
# add indicators
hybrid_df <- my_df %>% 
  left_join(by_year, by = c("year" = "year")) %>%
  left_join(by_publisher, by = c("year" = "year", "publisher" = "publisher"))

#' ## Which licenses indicates hybrid OA availability?
#' 
#'  [dissemin](https://dissem.in/) compiled a list of licenses used in Crossref,
#'  which indicate OA availability. [oaDOI](https://oadoi.org) re-uses this list. 
#'  This list can be found here:
#'  
#'  <https://github.com/dissemin/dissemin/blob/0aa00972eb13a6a59e1bc04b303cdcab9189406a/backend/crossref.py#L89>
#'   license per publisher and year
#' (replace group_by argument, i.e., journal wehen you want to calculate license per journal)
#'  
#'  oaDOI added to this list  IEEE's OA license:
#'  `http://www.ieee.org/publications_standards/publications/rights/oapa.pdf`
licence_patterns <- c("creativecommons.org/licenses/",
                      "http://koreanjpathol.org/authors/access.php",
                      "http://olabout.wiley.com/WileyCDA/Section/id-815641.html",
                      "http://pubs.acs.org/page/policy/authorchoice_ccby_termsofuse.html",
                      "http://pubs.acs.org/page/policy/authorchoice_ccbyncnd_termsofuse.html",
                      "http://pubs.acs.org/page/policy/authorchoice_termsofuse.html",
          #            "http://www.elsevier.com/open-access/userlicense/1.0/",
                      "http://www.ieee.org/publications_standards/publications/rights/oapa.pdf")
#' now add indication to the dataset
cr_hybrid_df <- hybrid_df %>% 
  mutate(licence_ref = tolower(licence_ref)) %>%
  mutate(hybrid_license = ifelse(grepl(paste(licence_patterns, collapse = "|"), licence_ref), TRUE, FALSE)) %>%
  # remove trailing backslash
  mutate(licence_ref = gsub("\\/$", "", licence_ref)) %>%
  mutate(licence_ref = gsub("https", "http", licence_ref))
rio::export(cr_hybrid_df, "data/cr_hybrid_df_indicators.csv")

