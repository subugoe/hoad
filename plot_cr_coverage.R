#' How many hybrid OA journals were sponsored by Open APC participants that also share open licensing information via Crossref?
#' 
library(dplyr)
#' load facets results
jn_facets <- jsonlite::stream_in(file("data/jn_facets_df.json"))
#' get hybrid journals that have open licensing information in the period 2013-16
hybrid_cr <- jsonlite::stream_in(file("data/hybrid_license_indicators.json"))
#'
#' all journals from open apc dataset for which we retrieved facet counts from crossref 
n_journals_df <- jn_facets %>% 
  distinct(journal_title, publisher) %>%
  group_by(publisher) %>%
  summarise(n_journals = n_distinct(journal_title))
#' all journals from open apc dataset for which we retrieved facet counts 
#' AND from licensing info from crossref 
n_hoa_df <- hybrid_cr %>%
  distinct(journal_title, publisher) %>%
  group_by(publisher) %>%
  summarise(n_hoa_journals = n_distinct(journal_title))
#' merge them into one dataframe
cvr_df <- left_join(n_journals_df, n_hoa_df, by = "publisher") %>%
#' and prepare analysis of top 10 publishers   
  tidyr::replace_na(list(n_hoa_journals = 0)) %>%
  arrange(desc(n_journals)) %>%
  mutate(publisher = forcats::as_factor(publisher)) %>%
  mutate(publisher = forcats::fct_other(publisher, drop = publisher[21:length(publisher)])) %>%
  ungroup() %>%
  group_by(publisher) %>%
  summarise(n_journals = sum(n_journals), n_hoa_journals = sum(n_hoa_journals))
#' plot
ggplot(cvr_df,
       aes(x = n_journals, xend = n_hoa_journals, y = publisher, color = group)) +
  ggalt::geom_dumbbell(
    colour="#30638E",
    colour_xend="#EDAE49",
    colour_x="#30638E",
    size_x=3.5,
    alpha = 0.9,
    size_xend = 3.5
  ) +
  scale_y_discrete(limits = rev(levels(cvr_df$publisher))) +
  scale_x_continuous(breaks = seq(0, 1500, by = 250)) +
  labs(x = "Number of Hybrid OA Journals", 
       y = NULL,
       title = "Have publishers registered open license metadata for\nhybrid open access journals at Crossref?",
       subtitle = "Notice that only those hybrid open access journals were included where\nacademic institutions sponsored the publication fee according to the Open APC initiative"
  ) +
  geom_text(data=cvr_df, 
            aes(x=850, y= "Elsevier BV", label="with Crossref licensing infos"),
            color="#EDAE49", hjust=1, size=3, nudge_x=-10) +
  geom_text(data=cvr_df, 
            aes(x=900, y= "Elsevier BV", label="All"),
            color="#30638E", hjust=0, size=3, nudge_x=10) +
  theme_minimal(base_family="Arial Narrow") +
  theme(plot.margin=margin(30,30,30,30)) +
  theme(panel.grid.minor=element_blank()) +
  theme(axis.ticks=element_blank()) +
  theme(panel.grid.major.y=element_blank()) +
  theme(panel.border=element_blank())
ggsave("img/licensing_coverage.png", width = 9, height = 6, dpi = 450)
