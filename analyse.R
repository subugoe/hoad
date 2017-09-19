#' ## Which licenses indicates hybrid OA availability?
#' 
#'  [dissemin](https://dissem.in/) compiled a list of licenses used in Crossref,
#'  which indicate OA availability. [oaDOI](https://oadoi.org) re-uses this list. 
#'  This list can be found here:
#'  
#'  <https://github.com/dissemin/dissemin/blob/0aa00972eb13a6a59e1bc04b303cdcab9189406a/backend/crossref.py#L89>
#'  
#'  We will add this list with IEEE's OA license:
#'  `http://www.ieee.org/publications_standards/publications/rights/oapa.pdf`
licence_patterns <- c("creativecommons.org/licenses/",
                      "http://koreanjpathol.org/authors/access.php",
                      "http://olabout.wiley.com/WileyCDA/Section/id-815641.html",
                      "http://pubs.acs.org/page/policy/authorchoice_ccby_termsofuse.html",
                      "http://pubs.acs.org/page/policy/authorchoice_ccbyncnd_termsofuse.html",
                      "http://pubs.acs.org/page/policy/authorchoice_termsofuse.html",
                      "http://www.elsevier.com/open-access/userlicense/1.0/",
                      "http://www.ieee.org/publications_standards/publications/rights/oapa.pdf")
#' now add indication to the dataset
cr_hybrid_df <- rio::import("data/cr_hybrid_df.xlsx")
cr_hybrid_df <- cr_hybrid_df %>% 
  mutate(hybrid_license = ifelse(grepl(paste(licence_patterns, collapse = "|"), licence_ref), TRUE, FALSE))
#' 
#' ## How to explore these data?
#' 
#' Example Journal The Journal of Physical Chemistry. ISSN 1932-7447
hybrid_sub <- filter(cr_hybrid_df, issn == "1932-7447") %>%
  mutate(prop = as.numeric(licence_ref_n) / as.numeric(all_published))
library(ggplot2)
library(plotly)
p <- ggplot(hybrid_sub, aes(year, prop, fill = licence_ref)) + 
  geom_bar(stat = "identity") +
  xlab("Year") + 
  ylab("Proportion Hybrid OA / Journal Output") + 
  viridis::scale_fill_viridis("Licenses", discrete = TRUE) +
  theme_minimal()
p
plotly::ggplotly(p)
#' good
# tmp
# 
# pp <- ggplot() + 
#   # all
#   geom_bar(data = all, aes(year, articles, fill = "All"), stat = "identity") +
#   # hybrid
#   geom_bar(data = hybrid_t, aes(year, articles, fill = "hybrid"), stat = "identity") + 
#   # openapc
#   geom_bar(data = oapc_, aes(year, articles, fill = "Open APC"), stat = "identity") + 
#   scale_fill_manual(values = c("#d9eef2", "#8da4cc", "#464a56")) +
#   theme_minimal()
# plotly::ggplotly(pp)
