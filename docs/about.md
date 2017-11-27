# About the Hybrid OA Dashboard





## Summary 

This open source dashboard presents the uptake of hybrid open access for 2,905 journals from 30 publishers between 2013 - 2017. Hybrid open access journals are included when they meet the following two conditions:

1. academic institutions sponsored the publication fee or have agreed upon an offsetting agreement according to the [Open APC initiative](https://github.com/openapc/openapc-de),
2. publishers shared licensing information about fulltext accessibility and re-use rights with  [Crossref](https://www.crossref.org/).

By bringing together openly available datasets about hybrid open access into one easy-to-use tool, this dashboard demonstrates how existing pieces of an evolving and freely available data infrastructure for monitoring scholarly publishing can be re-used to gain a better understanding of hybrid open access publishing. It, thus, contributes to recent calls from the [Open Access 2020 Initiative](https://oa2020.org/) and [Open Knowledge](https://blog.okfn.org/2017/10/24/understanding-the-costs-of-scholarly-publishing-why-we-need-a-public-data-infrastructure-of-publishing-costs/) aiming at a data-driven debate about how to transition subscription-based journal publishing to open access.

This document gives information about the study design, as well as how to use the dashboard. Because this open source dashboard is built around already existing infrastructure services for scholarly publishing, this doc will also provide guidance about how publishers can properly report hybrid open access journal articles to Crossref in accordance with evolving standards like the [ESAC guidelines](http://esac-initiative.org/its-the-workflows-stupid-what-is-required-to-make-offsetting-work-for-the-open-access-transition/).

## Data and methods 

Many publishers offer hybrid open access journals. However, because of non-standardized practices to report open access, it is hard to keep track of how many articles were made immediately available in this way, and to what extent these figures relate to the overall article volume. One common problem is to discover articles in subscription-based journals, which were made immediately open access, another is to identify proper licensing information about access and re-use rights [@Laakso_2016; @Bj_rk_2017; @Piwowar_2017]. 

To reflect these problems in our study design, data from the [Open APC initiative](https://github.com/OpenAPC/openapc-de/) was used for identifying hybrid open access journals where articles were actually made openly available immediatlely after publication. The [Open APC initiative](https://github.com/OpenAPC/openapc-de/) crowd-source information about spending on open access journal articles from various international research organisations. [Its openly available dataset](https://github.com/OpenAPC/openapc-de/blob/master/data/apc_de.csv) differentiates expenditure for articles published in hybrid and in full open access journals. It also has a dedicated dataset containing metadata about articles, which were made openly available as part of [offsetting deals](https://github.com/OpenAPC/openapc-de/tree/master/data/offsetting). 

After obtaining cost data about hybrid open access journal articles from the Open APC initiative, [Crossref's REST API](https://github.com/CrossRef/rest-api-doc) was queried to discover open access articles published in these journals, as well as to retrieve yearly article volumes for the period 2013 - 2017. Using the [rcrossref](https://github.com/ropensci/rcrossref) client, developed and maintained by the [rOpenSci initiative](https://ropensci.org/), the first API call retrieved all licenses URLs available per ISSN. To control possible name changes of publishers or journal titles over the period, only the most frequent facet field name was used. After matching and normalizing  licensing URLs indicating open access articles with the help of the [dissem.in / oaDOI access indicator list](https://github.com/dissemin/dissemin/blob/0aa00972eb13a6a59e1bc04b303cdcab9189406a/backend/crossref.py#L89), a second API call checked licensing metadata to exclude delayed open access articles by using the [Crossref's REST API filters](https://github.com/CrossRef/rest-api-doc#filter-names) `license.url` and `license.delay`. Because journal business models can change from hybrid to full open access over time, the [Directory of Open Access Journals (DOAJ)](https://doaj.org/), a curated list of full open access journals, was finally checked to exclude these journals. 

Although Crossref covers many open access journals, not all publishers share comprehensive metadata about access and re-use including licenses and embargo date via Crossref. In our case, 30 publishers provided licensing
metadata via the Crossref API, representing 22 % of all publishers included in our study. At the journal-level, 72 % of all hybrid open access journal titles covered by the Open APC initiative share proper licensing metadata with Crossref.




![](../img/licensing_coverage.png)
*Figure: Overview of Crossref licensing coverage per publisher. Yellow dots represent the number of hybrid open access journals disclosed by the Open APC initiative with licensing metadata, blue dots the overall number of hybrid open access journals in our sample.*

Methods are implemented in R and are openly available in the source code repository of this dashboard hosted on  [GitHub](https://github.com/njahn82/hybrid_oa_dashboard) together with the compiled datasets.

## Using the dashboard

Choose a publisher or journal via the select boxes in the left sidebar. Publisher names are decreasingly sorted according to the number of hybrid open access articles published. Corresponding journals are filtered conditionally to the publisher selection and are sorted alphabetically.

### Hybrid OA uptake

Information is presented using dynamic graphs. The first tab of the upper graph shows the relational uptake of hybrid open access, the second tab the absolute number of published hybrid open access articles. Bar charts are sub-grouped according to the licensing links found via Crossref.

### Institutional support

The lower left chart compares the number of articles found via Open APC and Crossref for the selection. The lower right chart indicates from which countries the institutional support originated from. The figures are based on the Open APC datasets.

![](../img/screenshot.png)
*Figure: Screenshot of the Hybrid OA Dashboard*

## As a publisher, how can I support proper hybrid open access monitoring?

Crossref supports publishers who wish to make licensing metadata available via the Crossref APIs:
<https://support.crossref.org/hc/en-us/articles/214572423-License-metadata-Access-Indicators->

As a publisher to be best represented in this dashboard, make sure to include license URL element `license_ref` and a `start_date` equal to the date of publication. Such workflow complies with ESAC's  recommendations for article workflows and services for offsetting / open access transformation agreements [@Geschuhn_2017].

## Technical notes

This [Shiny web application](https://shiny.rstudio.com/) is built using [flexdashboard](http://rmarkdown.rstudio.com/flexdashboard/) package. The app is powered by the excellent graphic packages [plotly](https://github.com/ropensci/plotly), [ggplot2](http://ggplot2.tidyverse.org/) and [ggalt](https://github.com/hrbrmstr/ggalt), as well as  [readr](http://readr.tidyverse.org/) for data import. Data analysis makes use of [dplyr](http://dplyr.tidyverse.org/).

The source code repository of this dashboard hosted on [GitHub](https://github.com/njahn82/hybrid_oa_dashboard). 

## How to contribute?

This dashboard has been developed in the open using open tools. There are a number of ways you can help make the dashboard better:

- If you don’t understand something, please let me know and [submit an issue](https://github.com/njahn82/hybrid_oa_dashboard/issues).

- Feel free to add new features or fix bugs by sending a [pull request](https://github.com/njahn82/hybrid_oa_dashboard/pulls).

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/njahn82/hybrid_oa_dashboard/CONDUCT.md). By participating in this project you agree to abide by its terms.

## Meta

Author: Najko Jahn (Scholarly Communication Analyst, [SUB Göttingen](https://www.sub.uni-goettingen.de/)), 2017.

The R Markdown file, which includes the underlying source code for this document, is available [here](https://github.com/njahn82/hybrid_oa_dashboard/blob/master/docs/about.Rmd).

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

## Bibliography
