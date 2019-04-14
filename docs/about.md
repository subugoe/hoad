---
title: "About the Hybrid OA Dashboard"
date: "updated 2019-04-14"
output:
  html_document:
    df_print: paged
    keep_md: yes
    toc: yes
    toc_depth: 2
    toc_float: yes
bibliography: references.bib
csl: frontiers.csl
---





## Summary 

[This open source dashboard](https://subugoe.shinyapps.io/hybridoa/) presents the uptake of hybrid open access for 3,988 subscription-based journals from 52 publishers between 2013 - 2019. During this seven years period, these journals provided immediate open access to 150,864 articles, representing 2.7% of the total article volume studied.

Hybrid open access journals are included when they meet the following two conditions:

1. Academic institutions sponsored immediate open access publication of individual articles in subscription-based journals according to the [Open APC initiative](https://github.com/openapc/openapc-de),
2. Publishers provided open content license statements via [Crossref](https://www.crossref.org/) including information about whether articles were made openly available upon publication or not.

By bringing together openly available datasets about hybrid open access into one easy-to-use tool, this dashboard demonstrates how existing pieces of an evolving and freely available data infrastructure for monitoring scholarly publishing can be re-used to gain a better understanding of hybrid open access publishing. It, thus, contributes to recent calls from the [Open Access 2020 Initiative](https://oa2020.org/) and [Open Knowledge](https://blog.okfn.org/2017/10/24/understanding-the-costs-of-scholarly-publishing-why-we-need-a-public-data-infrastructure-of-publishing-costs/) aiming at a data-driven debate about how to transition subscription-based journal publishing to open access.

This document gives information about the analytical design, as well as how to use the dashboard. Because this open source dashboard was built around already existing infrastructure services for scholarly publishing, discussion will also include guidance about how publishers can properly report hybrid open access journal articles to Crossref in accordance with evolving standards like the [ESAC guidelines](http://esac-initiative.org/its-the-workflows-stupid-what-is-required-to-make-offsetting-work-for-the-open-access-transition/).

## Background and motivation

Many publishers offer hybrid open access journals [@Suber_2012]. However, because of non-standardized reporting practices, it is hard to keep track of how many articles these journals provided immediately in open access, and to what extent these figures relate to the overall article volume published [@Bj_rk_2017]. In particular, determining subscription-based journals that already did publish open access articles, as well as obtaining licensing information about access and re-use rights is challenging [@Laakso_2016; @Piwowar_2017].

While previous biblioemtric studies about hybrid open access publishing used data reported from publishers [@Bj_rk_2017] or obtained them manually from publisher websites [@Laakso_2016], [Unpaywall](https://unpaywall.org/) from [Impactstory](https://github.com/impactstory) has become a popular data source to find open access articles [@Else_2018]. This openly available service, which is integrated in major bibliometric databases like the Web of Science or Scopus, links DOIs from Crossref, a DOI registration agency for scholarly works, to openly available full-texts. Following @Piwowar_2017, bibliometric analysis re-using Unpaywall data define hybrid open access as publisher provided open access with open content license statements, which were not published in fully open access journals contained in the [Directory of Open Access Journals (DOAJ)](https://doaj.org/) (e.g. @Bosman_2018 or the [German Open Access Monitor](https://open-access-monitor.de/#/)). Unpaywall obtains these license statements from Crossref and publisher websites.

However, using Unpaywall to discover hybrid open access in such a way is limited in two respects: first, there are some fully open access journals, which are not indexed in the DOAJ [@Rimmert_2017], presumably because these journals did not comply with its comprehensive inclusion criteria. Secondly, Unpaywall focusses on current open access provision, but does not track when the open access articles were made openly available, making it impossible to distinguish between immediate and delayed open access provision. While Unpaywall has greatly improved the discoverability of open access in general, its applicability to hybrid open access defined as immediate open access of individual articles in subscription-based journals remains limited for the above two reasons.

Lack of standardized and publicly available data  about hybrid open access publishing not only limits its quantitative study, but also informed policy-making around open access [@Laakso_2019]. Particularly, the business model of hybrid open access journals is challenged, because publisher often charge publication fees, also known as article processing charges (APC), to provide immediate open access to individual articles in addition to subscriptions [@Suber_2012]. Although it was initially envisioned that with growing funding opportunities for publication fees publishers would transition hybrid open access journals to fully open access [@Prosser_2003], it remains unclear to which extent the increasing willingness to pay for open access contributed to it, and how cost-effective these spendings were [@Bj_rk_2014; @Pinfield_2017]. 

Funders and libraries have responded to problems of missing evidence around hybrid open access publishing in the last years. To make expenditures more transparent, a growing number of institutions have started to disclose individual articles they supported as open data. The Wellcome Trust, the Austrian Science Fund FWF and British universities were among the first who shared spendings for open access articles in hybrid open access journals [@Kiley_2014; @fwf_apc_13; @jisc_14]. The [Open APC Initiative](https://github.com/openapc/openapc-de) collects and standardizes these openly available spending data together with crowd-sourced expenditures. Because Crossref, a DOI registration agency for scholarly works indexes most articles where institutions sponsored publication fees, Open APC uses its metadata services to make open access expenditures comparable at the institutional, journal and publisher level [@Jahn_2016; @Pieper_2018]. So far, the Open APC Initiative disclosed 55,616 hybrid open access articles supported by 278 research performing organisations and funders between 2013 - 2019.

Additionally, funders and libraries have developed  compliance criteria including machine-readable Creative Commons license statements to improve the discoverability of open access content. The Sponsoring Consortium for Open Access Publishing in Particle Physic -- SCOAP$^3$, for example, requires CC-BY licenses and archives funded articles in several formats including metadata in a dedicated repository. In Europe, the Wellcome Trust [automatically checks](https://compliance.cottagelabs.com/docs) if authors and publishers comply with a comprehensive set of metadata obligations [@Kiley_2015].  In the US, Chorus, a non-profit serving more than 50 publishers, uses freely available metadata from Crossref to present open access compliance for dedicated funders with [interactive dashboards](https://dashboard.chorusaccess.org/). 

In the light of a perceived slow and ineffective growth of open access, more and more funders and libraries alter their spending on subscription-based journals and individual open access articles published in these outlets. Notably, the [Open Access 2020 Initiative](https://oa2020.org/) calls for a transparent approach to converting budgets spent for subscriptions to open access business models. Likewise, the cOAlition S, a network of 11 research funders, released its widely discussed [Plan S](https://www.coalition-s.org/). Starting from 2020, members of the cOAlition S intend to discontinue funding of publication fees for individual open access articles in subscription-based journals. However, hybrid open access articles published under a transformative agreement, in which spendings for subscription and open access publication are considered together, will remain  eligible for funding. The Plan S also requires a commitment to full open access transition from the publishers. The cOAlition S refers to the [ESAC Initiative](http://esac-initiative.org/), which aims at standardizing open access workflows between publishers and research institutions, to observe these contracts. In 2017, ESAC, based at the German Max Planck Digital Library (MPDL), released guidance about how to implement transformative agreements. According to these guidelines, publishers have to ensure that only corresponding authors affiliated with the agreement institution are eligible for open access support. Furthermore, publishers need to provide rich metadata to Crossref including open access license information and reports about covered articles to the agreement institutions [@Geschuhn_2017]. Complementary to spendings for individual hybrid open access articles, some library consortia like the Swedish Bibsam or the British Jisc have started to make these reports openly available with the Open APC Initiative [@Lund_n_2018; @Pieper_2018].  

These developments show that open and standardized reporting is critical to monitor hybrid open access publishing. To encourage good data practices around the transition of subscription-based journals to open access, we propose the following characteristics hybrid open access journals must have to become included in monitoring exercises:

1. Academic institutions sponsored immediate open access publication of individual articles in subscription-based journals according to the Open APC initiative,
2. Publishers provided open content license statements via Crossref including information about whether articles were made openly available upon publication or not.

To our knowledge, this is the first approach that combines openly available data about the productivity of and the spending for hybrid open access journals. Using expenditures, it addresses the difficulties to identify hybrid open access journals, which already did publish individual open access articles. By utilizing the start date of license statements to distinguish immediate from delayed open access provision, our method extends existing approaches to discover open access articles with Crossref.


## Data and methods 

Our methods follow the Wickham-Grolemund approach to practice data science [@Wickham_2017]. After importing, cleaning  ("tidying") and transforming data from various sources ("Data Wrangling"),  summary statistics were calculated and visualized to understand and communicate the uptake of hybrid open access publishing. For the latter, we created a dashboard, which allows visual interaction with our data. Our workflow, illustrated in Figure and described more detailed in this section, was implemented in R using open data and tools, making it transparent and re-usable. 

![Summary of data and methods used, following the Wickham-Grolemund approach to practice data science [@Wickham_2017]](flow.png)

### Data Wrangling

To reflect the challenge of finding hybrid open access journals with published open access articles [@Laakso_2016], we started with a sample of hybrid open access journals from the [Open APC initiative](https://github.com/OpenAPC/openapc-de/). This open data initiative crowd-source information about spending on open access journal articles from various international research organisations. [Its openly available dataset](https://github.com/OpenAPC/openapc-de/blob/master/data/apc_de.csv) differentiates expenditure for articles published in hybrid and in fully open access journals. It also has a dedicated dataset containing information about articles, which were made openly available as part of [transformative agreements](https://github.com/OpenAPC/openapc-de/tree/master/data/offsetting), deals between publishers and large research organisations or consortia aiming at transitioning subscription-based licensing to open access business models. Using data from the [Open APC initiative](https://github.com/OpenAPC/openapc-de/), thus, ensured that only hybrid open access journals with at least one institutionally funded open access article were examined.

After obtaining data about hybrid open access journals from the Open APC initiative, [Crossref's REST API](https://github.com/CrossRef/rest-api-doc) was queried to discover open access articles published in these journals, as well as to retrieve yearly article volumes for the period 2013 - 2019. Using the [rcrossref](https://github.com/ropensci/rcrossref) client [@rcrossref], developed and maintained by the [rOpenSci initiative](https://ropensci.org/), the first API call retrieved all licenses URLs available per journal using all ISSN variants available in Open APC dataset. To control developments of the publishing market resulting in name changes of publishers or journal titles over time, only the most frequent facet field name was used. After matching and normalizing  licensing URLs indicating open access articles with the help of the [dissem.in / oaDOI access indicator list](https://github.com/dissemin/dissemin/blob/0aa00972eb13a6a59e1bc04b303cdcab9189406a/backend/crossref.py#L89), a second API call checked licensing metadata. Here, we excluded delayed open access articles by using the [Crossref's REST API filters](https://github.com/CrossRef/rest-api-doc#filter-names) `license.url` and `license.delay` for the every single year in period of 2013 - 2019. Because journal business models can change from hybrid to fully open access over time, the [Directory of Open Access Journals (DOAJ)](https://doaj.org/), a curated list of fully open access journals, was finally checked to exclude these journals by ISSNs. To improve this matching, DOAJ data was enriched with further ISSN variants from @Rimmert_2017. Journals with a OA proportion above 0.95 over two years were also excluded.

Using Unpaywall data, we were also able to determine additional articles with open content license statements and compared them with our journal sample. After importing the Unpaywall dump to a Google Big Query instance, we queried for all articles where  license statements were available for the version of record and that appeared in non-DOAJ indexed journals since 2013. Next, we matched our hybrid open access journal sample with of Unpaywall using all ISSN variants for each journal provided by Crossref. Finally, we matched articles contained in our sample with that of Unpaywall using the DOI.

Information about corresponding authors play a crucial role in open access funding. Because not all publishers share standardized affiliation data with Crossref, we text-mined our article sample for email addresses, assuming that email domains can be used as rough approximation of the affiliation of the first respective corresponding author at the time of publication. First, we interfaced the [Crossref TDM service](https://support.crossref.org/hc/en-us/articles/215750183-Crossref-Text-and-Data-Mining-Services) using the [crminer](https://github.com/ropensci/crminer) R-client from rOpenSci [@crminer], downloaded the full-texts and extracted the first email occurrence per article. Next, we extracted the email domains and its parts with [urltools](https://CRAN.R-project.org/package=urltools) [@urltools]. To avoid mis-use, particularly academic spamming, source code and data used for this text-mining exercise are currently stored in a privately git-repository until it is secured that no full author emails are accidentally shared.

### Data Accuracy

Notice that our estimates about the extent of hybrid open access publishing are likely to be conservative. Probably, not all authors and institutions share information about hybrid open access spending with the Open APC initiative. Similarly, not all publishers shared comprehensive metadata about access and re-use with Crossref. To assess data accuracy, we first describe how many hybrid open journals covered by the Open APC initiative provided license statements via Crossref between 2013 - 2019. Next, we evaluated the accurary of our automated retrieval using article random samples. Recall and precision for obtaining hybrid open access articles from Crossref and for extracting email addresses from full-texts were investigated.

#### Coverage accuracy

In the case of hybrid open access journals represented in the Open APC datasets, 52 publishers provided licensing statements via the Crossref API, representing 31 % of all publishers studied. At the journal-level, 82 % of all hybrid open access journal titles covered by the Open APC initiative shared proper licensing statements with Crossref. Figure 1 provides a breakdown of licencing metadata coverage per publisher.




![](../img/licensing_coverage.png)

*Figure 1: Overview of Crossref licensing coverage per publisher. Yellow dots represent the number of hybrid open access journals disclosed by the Open APC initiative with licensing metadata, blue dots the overall number of hybrid open access journals in our sample.*

Comparing the number of articles found via Open APC and Crossref, furthermore suggests that not all publishers share licensing metadata retrospectively. Take for instance journals published by Springer Nature: In 2015, more hybrid open access articles were reported to the Open APC initiative than registered with an open license via Crossref (see Figure 2). 



![](../img/oapc_cr_springer.png)

*Figure 2: Comparing Springer Nature hybrid open access journal articles available via Crossref with  disclosed spending information via the Open APC initiative.*

#### Retrieval accuracy 


34,420 out of 55,616 hybrid open access articles disclosed by the Open APC initiative provide license statements with Crossref that comply with our definition, representing a proportion of 62 %. To assess the accuracy of our retrieval, we manually checked a random sample of 100 Open APC articles not being confirmed as immediate hybrid open access articles according to our definition querying Crossref. We found that 93 articles in fact did not share license statements with Crossref using the license node. The other 7 articles did report an open content license, but with a delay (`delay-in-days` metadata field) above 0.[^1]

Next to the recall, we also checked the precision of our retrieval using a random sample of 100 articles. We retrievd the correct license statements including start date for all articles in our sample. We also determined whether all journal articles were original articles or reviews. 9,400 % articles were characterized as original articles or review, confirming previous studies [@Piwowar_2017]. Other document types were conference abstracts (N = 0), a medical guideline, a comment and a short report.

<!-- Next, we evaluated the accurary of our automated methods using article random samples. Recall and precision for obtaining hybrid open access articles from Crossref and for extracting email addresses from full-texts were investigated. -->


### Dashboard Implementation

Data were gathered on 2019-02-04. Methods were implemented in R and were made openly available in the source code repository of this project hosted on [GitHub](https://github.com/subugoe/hybrid_oa_dashboard) together with the compiled datasets. A [Shiny web application](https://shiny.rstudio.com/) was built to present the results using [flexdashboard](http://rmarkdown.rstudio.com/flexdashboard/) package. The app is powered by the graphic packages [plotly](https://github.com/ropensci/plotly), [ggplot2](http://ggplot2.tidyverse.org/) and [ggalt](https://github.com/hrbrmstr/ggalt), as well as  [readr](http://readr.tidyverse.org/) for data import. Data analysis made use of [dplyr](http://dplyr.tidyverse.org/).


## Results 

Using data from Open APC and Crossref, we found 150,864  open access articles published in
3,988 subscription-based journals from 52 publishers between 2013 - 2019. These articles accounted for about 2.7% of the overall journal article volume investigated.

Results at the publisher and journal level are accessible and browsable through an [interactive dashboard using dynamic graphs](https://subugoe.shinyapps.io/hybridoa/). Launching the app shows up the overall results that can be subsetted by publisher or journal via the select boxes in the left sidebar. Publisher names are decreasingly sorted according to the number of hybrid open access articles published. Corresponding journals are filtered conditionally to the publisher selection and are sorted alphabetically.

![*Figure 2: Screenshot of the Hybrid OA Dashboard available at <https://subugoe.shinyapps.io/hybridoa/>*](../img/screenshot.png)

### Hybrid OA uptake

The upper part of the dashboard allows to explore the annual development of hybrid open access publishing between 2013 - 2019. The first tab shows the relative uptake of hybrid open access, the second tab the absolute number of published hybrid open access articles on a yearly basis. Bar charts are sub-grouped according to the licensing links found via Crossref. Overall results indicate that the number and proportion of hybrid open access journal articles rose between 2013 (4,426 articles, OA share: 0.56 %) and 2018  (48,961 articles, OA share: 4.7 %).




Table 1 presents an additional breakdown by publishers, contrasting the number of journals with the number of articles found. The three publishers Elsevier BV, Springer Nature and Wiley-Blackwell are leading, accounting for the largest proportion of hybrid open access journals (79 %) and open access articles (82 %) found.


<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Publisher"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Journals (in %)"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Article volume (in %)"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Hybrid OA article volume"],"name":[4],"type":["int"],"align":["right"]},{"label":["OA proportion per publisher (in %)"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Overall OA proportion (in %)"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"Elsevier BV","2":"991 (24.82 %)","3":"2445292 (43.35 %)","4":"57629","5":"2.36","6":"38.20"},{"1":"Springer Nature","2":"1626 (40.73 %)","3":"1089158 (19.31 %)","4":"49650","5":"4.56","6":"32.91"},{"1":"Wiley","2":"532 (13.33 %)","3":"700443 (12.42 %)","4":"15819","5":"2.26","6":"10.49"},{"1":"Oxford University Press (OUP)","2":"134 (3.36 %)","3":"275727 (4.89 %)","4":"5023","5":"1.82","6":"3.33"},{"1":"American Chemical Society (ACS)","2":"50 (1.25 %)","3":"274849 (4.87 %)","4":"4678","5":"1.70","6":"3.10"},{"1":"Informa UK Limited","2":"334 (8.37 %)","3":"185982 (3.3 %)","4":"1416","5":"0.76","6":"0.94"},{"1":"American Physical Society (APS)","2":"9 (0.23 %)","3":"109046 (1.93 %)","4":"4595","5":"4.21","6":"3.05"},{"1":"Royal Society of Chemistry (RSC)","2":"33 (0.83 %)","3":"98625 (1.75 %)","4":"306","5":"0.31","6":"0.20"},{"1":"Institute of Electrical and Electronics Engineers (IEEE)","2":"47 (1.18 %)","3":"91800 (1.63 %)","4":"138","5":"0.15","6":"0.09"},{"1":"IOP Publishing","2":"40 (1 %)","3":"84549 (1.5 %)","4":"4493","5":"5.31","6":"2.98"},{"1":"AIP Publishing","2":"8 (0.2 %)","3":"79547 (1.41 %)","4":"320","5":"0.40","6":"0.21"},{"1":"American Geophysical Union (AGU)","2":"13 (0.33 %)","3":"34912 (0.62 %)","4":"1299","5":"3.72","6":"0.86"},{"1":"Cambridge University Press (CUP)","2":"36 (0.9 %)","3":"27246 (0.48 %)","4":"321","5":"1.18","6":"0.21"},{"1":"Trans Tech Publications","2":"2 (0.05 %)","3":"17790 (0.32 %)","4":"142","5":"0.80","6":"0.09"},{"1":"American Psychological Association (APA)","2":"17 (0.43 %)","3":"14589 (0.26 %)","4":"212","5":"1.45","6":"0.14"},{"1":"The Optical Society","2":"3 (0.08 %)","3":"9927 (0.18 %)","4":"7","5":"0.07","6":"0.00"},{"1":"International Union of Crystallography (IUCr)","2":"7 (0.18 %)","3":"9567 (0.17 %)","4":"1004","5":"10.49","6":"0.67"},{"1":"American Astronomical Society","2":"1 (0.03 %)","3":"9462 (0.17 %)","4":"284","5":"3.00","6":"0.19"},{"1":"S. Karger AG","2":"20 (0.5 %)","3":"8945 (0.16 %)","4":"530","5":"5.93","6":"0.35"},{"1":"Japan Society of Applied Physics","2":"2 (0.05 %)","3":"8860 (0.16 %)","4":"206","5":"2.33","6":"0.14"},{"1":"Georg Thieme Verlag KG","2":"3 (0.08 %)","3":"6444 (0.11 %)","4":"11","5":"0.17","6":"0.01"},{"1":"The Company of Biologists","2":"3 (0.08 %)","3":"4964 (0.09 %)","4":"298","5":"6.00","6":"0.20"},{"1":"Walter de Gruyter GmbH","2":"16 (0.4 %)","3":"4948 (0.09 %)","4":"89","5":"1.80","6":"0.06"},{"1":"American Association for the Advancement of Science (AAAS)","2":"1 (0.03 %)","3":"4858 (0.09 %)","4":"4","5":"0.08","6":"0.00"},{"1":"American Dairy Science Association","2":"1 (0.03 %)","3":"4635 (0.08 %)","4":"195","5":"4.21","6":"0.13"},{"1":"The Royal Society","2":"5 (0.13 %)","3":"4080 (0.07 %)","4":"20","5":"0.49","6":"0.01"},{"1":"Ovid Technologies (Wolters Kluwer Health)","2":"2 (0.05 %)","3":"4075 (0.07 %)","4":"50","5":"1.23","6":"0.03"},{"1":"American Meteorological Society","2":"7 (0.18 %)","3":"3773 (0.07 %)","4":"69","5":"1.83","6":"0.05"},{"1":"Geological Society of London","2":"4 (0.1 %)","3":"3322 (0.06 %)","4":"247","5":"7.44","6":"0.16"},{"1":"Acoustical Society of America (ASA)","2":"1 (0.03 %)","3":"2890 (0.05 %)","4":"1","5":"0.03","6":"0.00"},{"1":"American Vacuum Society","2":"2 (0.05 %)","3":"2637 (0.05 %)","4":"18","5":"0.68","6":"0.01"},{"1":"Bioscientifica","2":"5 (0.13 %)","3":"2360 (0.04 %)","4":"171","5":"7.25","6":"0.11"},{"1":"Portland Press Ltd.","2":"5 (0.13 %)","3":"2306 (0.04 %)","4":"318","5":"13.79","6":"0.21"},{"1":"The Electrochemical Society","2":"2 (0.05 %)","3":"2039 (0.04 %)","4":"750","5":"36.78","6":"0.50"},{"1":"The Endocrine Society","2":"3 (0.08 %)","3":"2025 (0.04 %)","4":"27","5":"1.33","6":"0.02"},{"1":"Brill","2":"5 (0.13 %)","3":"1617 (0.03 %)","4":"43","5":"2.66","6":"0.03"},{"1":"American Association of Pharmaceutical Scientists (AAPS)","2":"2 (0.05 %)","3":"1589 (0.03 %)","4":"97","5":"6.10","6":"0.06"},{"1":"Rockefeller University Press","2":"3 (0.08 %)","3":"1529 (0.03 %)","4":"177","5":"11.58","6":"0.12"},{"1":"American Speech Language Hearing Association","2":"1 (0.03 %)","3":"680 (0.01 %)","4":"21","5":"3.09","6":"0.01"},{"1":"IWA Publishing","2":"2 (0.05 %)","3":"657 (0.01 %)","4":"14","5":"2.13","6":"0.01"},{"1":"Korean Physical Society","2":"1 (0.03 %)","3":"518 (0.01 %)","4":"1","5":"0.19","6":"0.00"},{"1":"Royal College of Psychiatrists","2":"2 (0.05 %)","3":"443 (0.01 %)","4":"31","5":"7.00","6":"0.02"},{"1":"Schattauer GmbH","2":"1 (0.03 %)","3":"272 (0 %)","4":"5","5":"1.84","6":"0.00"},{"1":"Antiquity Publications","2":"1 (0.03 %)","3":"252 (0 %)","4":"2","5":"0.79","6":"0.00"},{"1":"Mineralogical Society of America","2":"1 (0.03 %)","3":"231 (0 %)","4":"6","5":"2.60","6":"0.00"},{"1":"Informa Healthcare","2":"2 (0.05 %)","3":"217 (0 %)","4":"3","5":"1.38","6":"0.00"},{"1":"Pleiades Publishing Ltd","2":"1 (0.03 %)","3":"169 (0 %)","4":"1","5":"0.59","6":"0.00"},{"1":"Mineralogical Society","2":"1 (0.03 %)","3":"161 (0 %)","4":"1","5":"0.62","6":"0.00"},{"1":"Ubiquity Press, Ltd.","2":"1 (0.03 %)","3":"151 (0 %)","4":"110","5":"72.85","6":"0.07"},{"1":"Universidad Complutense de Madrid (UCM)","2":"1 (0.03 %)","3":"96 (0 %)","4":"4","5":"4.17","6":"0.00"},{"1":"Society of Economic Geologists","2":"1 (0.03 %)","3":"81 (0 %)","4":"4","5":"4.94","6":"0.00"},{"1":"Guttmacher Institute","2":"1 (0.03 %)","3":"61 (0 %)","4":"4","5":"6.56","6":"0.00"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

*Table 1: Hybrid open access journal and article breakdown by publisher.*



Numbers and proportion of hybrid open access journal articles varies across publishers and journals. In the year 2017, for example, the mean open access proportion per Springer Nature journal was 12 % (SD = 10 %), whereas the  mean open access articles proportion per journal published by Elsevier BV was 4.2 % (SD = 5.3 %). Figure 3 shows the variations for the five publishers with the largest number of hybrid open access journals in 2017 according to our data.



![](../img/oa_variation.png)

*Figure 3: Box plot characterizing spread and differences of the share of open access articles provided by subscription-based journal per publisher in 2017 using five summary statistics (the median, the 25th and 75th percentiles, and 1.5 times the inter-quartile range between the first and third quartiles), and visualizing all outlying points individually.*

### Institutional support

In addition to bibliographic metadata, institutional support either for publication fees or as part of central agreements between research organisations and publishers (offsetting) was also studied.
The lower left chart in the dashboard compares the number of articles found via Open APC and Crossref for the selection. The lower right chart indicates from which countries the institutional support originated from. 

Notice that it is very likely that the overall decrease of spending for hybrid open access reported to the Open APC initiative in 2019 is due to a lag between the time that payments were made and expenditures were reported to the initiative. Comparing the number of articles found via Open APC and Crossref, furthermore suggests that not all publishers share licensing metadata retrospectively. Take for instance journals published by Springer Nature: between 2013 and 2015 more open access articles were reported to the Open APC initiative than registered with an open license via Crossref (see Figure 2). 


## Discussion and conclusion

This dashboard demonstrates the uptake of hybrid open access publishing for a sample of subscription-based journals where institutional support facilitated the open access publication of individual articles, and where licensing metadata about the open access status were made available via Crossref. In using open data sources and tools to analyse and present these data, this dashboard demonstrates how monitoring of hybrid open access can become more transparent and reproducible.

The presented longitudinal findings are consistent with earlier studies, confirming the growth of hybrid open access publishing. According to @Laakso_2016 hybrid open access publishing increased between 2007 - 2013. The authors identified 13,994 hybrid open access articles published in 2,714 different journals during 2013. @Bj_rk_2017 also observed an increase since 2014, presumably because of  centralized agreements with large publishers. Notably Springer Nature has started to offer offsetting deals to large research organisations like the Max Planck Society and national consortia since then [@Geschuhn_2017]. But also recent funding policies in favor of hybrid open access, notably in the UK, likely influenced the uptake of hybrid open access publishing [@Pinfield_2017].

While our findings confirm the uptake of hybrid open access in recent years, related studies observed higher proportions of freely available articles in hybrid open access journals. Studying subscription-based journals with at least one identified hybrid open access article as well, @Laakso_2016 determined an open access share of 3.8 % for the period of 2011–2013. Using Crossref metadata, @Piwowar_2017 estimated an even higher proportion according to which 9.4 % of articles published in 2015 were provided as hybrid open access. Our future work will, therefore, focus on evaluation our retrieval strategy in terms of precision and recall in order to better understand these differences. 

@Piwowar_2017 also found that the percentage of open access provided by publishers, which was free to read, but where the journal was neither listed in the DOAJ nor provided licensing metadata, was even higher (17.6 %). Our study confirms that metadata workflows for hybrid open access publishing as suggested by initiatives like [ESAC](http://esac-initiative.org/) are not comprehensively implemented, yet. Only every fifth publisher in our sample shared licensing metadata via Crossref. In addition to this incomplete licensing coverage, our findings also suggest a gap between spending information available through the Open APC initiative and the total number of hybrid open access articles that have been registered with Crossref in recent years. A likely reason is that reporting to the Open APC initiative is voluntary [@Jahn_2016]. Therefore, presumably not all institutions contribute cost data or information about central aggrements to this initiative. However, not all hybrid open access articles were sponsored by institutions, but authors can make use of other resources to publish open access, or fees are waived [@Solomon_2011]. 

As institutional support of hybrid open access journals grows, the overall aim of this dashboard is to promote evolving standards and infrastructures for analyzing the transition of subscription-based journal publishing to open access. Crossref provides excellent guidance for publishers to make licensing metadata available via the Crossref APIs:
<https://support.crossref.org/hc/en-us/articles/214572423-License-metadata-Access-Indicators->. For being best represented in this dashboard, publishers will have to make sure to include license URL element `license_ref` and a `start_date` equal to the date of publication in the licensing metadata, which helps to identify open access journal content as well as to differentiate between immediate and delayed open access. Likewise, research institutions, funders, and libraries can increase transparency about hybrid open access publishing including offsetting deals by reporting funded articles to the Open APC initiative on a regular basis. Both practices comply with [ESAC's recommendation for article workflows and services for offsetting/ open access transformation agreements](http://esac-initiative.org/its-the-workflows-stupid-what-is-required-to-make-offsettin). As this dashboard demonstrates, following these guidelines will help to extend existing methods and data sources to monitor the transition of subscription-based journal publishing to open access in an open and transparent way.

## Meta

### How to contribute?

Dashboard and analysis have been developed in the open using open tools. There are a number of ways you can help make the this work better:

- If you don’t understand something, please let us know and [submit an issue](https://github.com/subugoe/hybrid_oa_dashboard/issues).

- Feel free to add new features or fix bugs by sending a [pull request](https://github.com/subugoe/hybrid_oa_dashboard/pulls).

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/subugoe/hybrid_oa_dashboard/CONDUCT.md). By participating in this project you agree to abide by its terms.

Author: Najko Jahn (Scholarly Communication Analyst, [SUB Göttingen](https://www.sub.uni-goettingen.de/)), 2017.

The R Markdown file, which includes the underlying source code for this document, is available [here](https://github.com/subugoe/hybrid_oa_dashboard/blob/master/docs/about.Rmd).

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

## Footnotes

[^1]: E.g., the following artice represented by <https://api.crossref.org/works/10.1039/c7dt03848h> did report a CC-BY license with a delay of 32. 

## Bibliography


  
