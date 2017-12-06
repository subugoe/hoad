---
title: "About the Hybrid OA Dashboard"
output:
  html_document:
    keep_md: yes
    toc: yes
    toc_depth: 2
    toc_float: yes
    df_print: paged
bibliography: references.bib
---





## Summary 

This open source dashboard presents the uptake of hybrid open access for 2,919 different journals from 31 publishers between 2013 - 2017. Hybrid open access journals are included when they meet the following two conditions:

1. academic institutions sponsored the publication fee or have agreed upon an offsetting agreement according to the [Open APC initiative](https://github.com/openapc/openapc-de),
2. publishers shared licensing information about fulltext accessibility and re-use rights with  [Crossref](https://www.crossref.org/).

By bringing together openly available datasets about hybrid open access into one easy-to-use tool, this dashboard demonstrates how existing pieces of an evolving and freely available data infrastructure for monitoring scholarly publishing can be re-used to gain a better understanding of hybrid open access publishing. It, thus, contributes to recent calls from the [Open Access 2020 Initiative](https://oa2020.org/) and [Open Knowledge](https://blog.okfn.org/2017/10/24/understanding-the-costs-of-scholarly-publishing-why-we-need-a-public-data-infrastructure-of-publishing-costs/) aiming at a data-driven debate about how to transition subscription-based journal publishing to open access.

This document gives information about the study design, as well as how to use the dashboard. Because this open source dashboard is built around already existing infrastructure services for scholarly publishing, this doc will also provide guidance about how publishers can properly report hybrid open access journal articles to Crossref in accordance with evolving standards like the [ESAC guidelines](http://esac-initiative.org/its-the-workflows-stupid-what-is-required-to-make-offsetting-work-for-the-open-access-transition/).

## Data and methods 

Many publishers offer hybrid open access journals. However, because of non-standardized practices to report open access, it is hard to keep track of how many articles were made immediately available in this way, and to what extent these figures relate to the overall article volume [@Bj_rk_2017]. In particular, it is challenging to identify those subscription-based journals that already did publish open access articles, as well as proper licensing information about access and re-use rights [@Laakso_2016; @Piwowar_2017]. 

To reflect the challenge of reporting hybrid open access in our study design, our sample of hybrid open access journals consisted of journals tracked by the [Open APC initiative](https://github.com/OpenAPC/openapc-de/) . This open data initiative crowd-source information about spending on open access journal articles from various international research organisations. [Its openly available dataset](https://github.com/OpenAPC/openapc-de/blob/master/data/apc_de.csv) differentiates expenditure for articles published in hybrid and in full open access journals. It also has a dedicated dataset containing metadata about articles, which were made openly available as part of [offsetting deals](https://github.com/OpenAPC/openapc-de/tree/master/data/offsetting). Using data from  the [Open APC initiative](https://github.com/OpenAPC/openapc-de/), thus, ensured that only those hybrid open access journals were examined, in which articles were actually made openly available immediately after publication.

After obtaining cost data about hybrid open access journal articles from the Open APC initiative, [Crossref's REST API](https://github.com/CrossRef/rest-api-doc) was queried to discover open access articles published in these journals, as well as to retrieve yearly article volumes for the period 2013 - 2017. Using the [rcrossref](https://github.com/ropensci/rcrossref) client, developed and maintained by the [rOpenSci initiative](https://ropensci.org/), the first API call retrieved all licenses URLs available per ISSN. To control possible name changes of publishers or journal titles over the period, only the most frequent facet field name was used. After matching and normalizing  licensing URLs indicating open access articles with the help of the [dissem.in / oaDOI access indicator list](https://github.com/dissemin/dissemin/blob/0aa00972eb13a6a59e1bc04b303cdcab9189406a/backend/crossref.py#L89), a second API call checked licensing metadata to exclude delayed open access articles by using the [Crossref's REST API filters](https://github.com/CrossRef/rest-api-doc#filter-names) `license.url` and `license.delay`. Because journal business models can change from hybrid to full open access over time, the [Directory of Open Access Journals (DOAJ)](https://doaj.org/), a curated list of full open access journals, was finally checked to exclude these journals. 

Notice that although Crossref covers many open access journals, not all publishers share comprehensive metadata about access and re-use including licenses and embargo date via Crossref. In our case, 31 publishers provided licensing
metadata via the Crossref API, representing 22 % of all publishers included in our study. At the journal-level, 72 % of all hybrid open access journal titles covered by the Open APC initiative share proper licensing metadata with Crossref.




![](../img/licensing_coverage.png)

*Figure: Overview of Crossref licensing coverage per publisher. Yellow dots represent the number of hybrid open access journals disclosed by the Open APC initiative with licensing metadata, blue dots the overall number of hybrid open access journals in our sample.*

Data were gathered on 2017-11-28. Methods were implemented in R and are openly available in the source code repository of this dashboard hosted on [GitHub](https://github.com/subugoe/hybrid_oa_dashboard) together with the compiled datasets. The [Shiny web application](https://shiny.rstudio.com/) was built using [flexdashboard](http://rmarkdown.rstudio.com/flexdashboard/) package. The app is powered by the excellent graphic packages [plotly](https://github.com/ropensci/plotly), [ggplot2](http://ggplot2.tidyverse.org/) and [ggalt](https://github.com/hrbrmstr/ggalt), as well as  [readr](http://readr.tidyverse.org/) for data import. Data analysis made use of [dplyr](http://dplyr.tidyverse.org/).


## Results 

Using data from the Open APC initiative and Crossref, we found 86,639  open access articles published in
2,919 subscription-based journals from 31 publishers between 2013 - 2017. Results are accessible and browsable through a interactive dashboard using dynamic graphs. Launching the app shows up the overall results. Choose a publisher or journal via the select boxes in the left sidebar. Publisher names are decreasingly sorted according to the number of hybrid open access articles published. Corresponding journals are filtered conditionally to the publisher selection and are sorted alphabetically.

![*Screenshot of the Hybrid OA Dashboard available at <https://najkoja.shinyapps.io/hybridoa/>*](../img/screenshot.png)

### Hybrid OA uptake

The upper part of the dashboard lets you explore the absolute and relative growth of hybrid open access publishing between 2013 - 2017. The first tab shows the relational uptake of hybrid open access, the second tab the absolute number of published hybrid open access articles. Bar charts are sub-grouped according to the licensing links found via Crossref.



An additional breakdown by publishers is presented in Table 1, contrasting the number of journals with the number of articles found. It shows that the three publishers Elsevier BV, Springer Nature	and Wiley-Blackwell are the leading publisher in our sample, accounting for the largest proportion of hybrid open access journals (93 %) and open access articles (84 %) found.


<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Publisher"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Journals (in %)"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Article volume (in %)"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Hybrid OA article volume"],"name":[4],"type":["int"],"align":["right"]},{"label":["OA proportion per publisher (in %)"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Overall OA proportion (in %)"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"Elsevier BV","2":"877 (30.03 %)","3":"1751502 (48.84 %)","4":"38347","5":"2.19","6":"44.26"},{"1":"Springer Nature","2":"1401 (47.98 %)","3":"742375 (20.7 %)","4":"26335","5":"3.55","6":"30.40"},{"1":"Wiley-Blackwell","2":"430 (14.73 %)","3":"517049 (14.42 %)","4":"8405","5":"1.63","6":"9.70"},{"1":"American Chemical Society (ACS)","2":"45 (1.54 %)","3":"204975 (5.72 %)","4":"4318","5":"2.11","6":"4.98"},{"1":"Institute of Electrical and Electronics Engineers (IEEE)","2":"33 (1.13 %)","3":"75422 (2.1 %)","4":"66","5":"0.09","6":"0.08"},{"1":"American Physical Society (APS)","2":"5 (0.17 %)","3":"70997 (1.98 %)","4":"1151","5":"1.62","6":"1.33"},{"1":"AIP Publishing","2":"6 (0.21 %)","3":"64005 (1.78 %)","4":"359","5":"0.56","6":"0.41"},{"1":"IOP Publishing","2":"32 (1.1 %)","3":"55140 (1.54 %)","4":"3342","5":"6.06","6":"3.86"},{"1":"Acoustical Society of America (ASA)","2":"1 (0.03 %)","3":"17537 (0.49 %)","4":"1","5":"0.01","6":"0.00"},{"1":"American Psychological Association (APA)","2":"16 (0.55 %)","3":"11360 (0.32 %)","4":"79","5":"0.70","6":"0.09"},{"1":"American Meteorological Society","2":"6 (0.21 %)","3":"8230 (0.23 %)","4":"41","5":"0.50","6":"0.05"},{"1":"The Company of Biologists","2":"3 (0.1 %)","3":"7978 (0.22 %)","4":"167","5":"2.09","6":"0.19"},{"1":"International Union of Crystallography (IUCr)","2":"7 (0.24 %)","3":"7374 (0.21 %)","4":"1162","5":"15.76","6":"1.34"},{"1":"S. Karger AG","2":"18 (0.62 %)","3":"6888 (0.19 %)","4":"394","5":"5.72","6":"0.45"},{"1":"Japan Society of Applied Physics","2":"1 (0.03 %)","3":"6861 (0.19 %)","4":"40","5":"0.58","6":"0.05"},{"1":"The Royal Society","2":"5 (0.17 %)","3":"6450 (0.18 %)","4":"20","5":"0.31","6":"0.02"},{"1":"Association for Research in Vision and Ophthalmology (ARVO)","2":"2 (0.07 %)","3":"4749 (0.13 %)","4":"1817","5":"38.26","6":"2.10"},{"1":"American Dairy Science Association","2":"1 (0.03 %)","3":"4489 (0.13 %)","4":"186","5":"4.14","6":"0.21"},{"1":"Portland Press Ltd.","2":"4 (0.14 %)","3":"3912 (0.11 %)","4":"126","5":"3.22","6":"0.15"},{"1":"Rockefeller University Press","2":"2 (0.07 %)","3":"3400 (0.09 %)","4":"60","5":"1.76","6":"0.07"},{"1":"American Vacuum Society","2":"2 (0.07 %)","3":"2632 (0.07 %)","4":"26","5":"0.99","6":"0.03"},{"1":"Oxford University Press (OUP)","2":"4 (0.14 %)","3":"2127 (0.06 %)","4":"55","5":"2.59","6":"0.06"},{"1":"Informa UK Limited","2":"2 (0.07 %)","3":"2021 (0.06 %)","4":"2","5":"0.10","6":"0.00"},{"1":"American Association of Pharmaceutical Scientists (AAPS)","2":"2 (0.07 %)","3":"1717 (0.05 %)","4":"55","5":"3.20","6":"0.06"},{"1":"Walter de Gruyter GmbH","2":"6 (0.21 %)","3":"1691 (0.05 %)","4":"36","5":"2.13","6":"0.04"},{"1":"The Optical Society","2":"1 (0.03 %)","3":"1590 (0.04 %)","4":"1","5":"0.06","6":"0.00"},{"1":"SAGE Publications","2":"2 (0.07 %)","3":"1490 (0.04 %)","4":"8","5":"0.54","6":"0.01"},{"1":"Cambridge University Press (CUP)","2":"2 (0.07 %)","3":"922 (0.03 %)","4":"17","5":"1.84","6":"0.02"},{"1":"American Speech Language Hearing Association","2":"1 (0.03 %)","3":"902 (0.03 %)","4":"12","5":"1.33","6":"0.01"},{"1":"Springer Fachmedien Wiesbaden GmbH","2":"2 (0.07 %)","3":"510 (0.01 %)","4":"8","5":"1.57","6":"0.01"},{"1":"Nomos Verlag","2":"1 (0.03 %)","3":"229 (0.01 %)","4":"3","5":"1.31","6":"0.00"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

*Table 1: Hybrid open access journal and article breakdown by publisher.*

### Institutional support

The lower left chart compares the number of articles found via Open APC and Crossref for the selection. The lower right chart indicates from which countries the institutional support were obtained from the Open APC datasets as well. It is very likely that the overall decrease of spending for hybrid open access reported to the Open APC initiative in 2017 is due to a lag between the time that payments were made and expenditures were reported to the initiative. 

Comparing the number of articles found via Open APC and Crossref, furthermore, suggests that not all publishers share licensing metadata retrospectively. Take for instance journals published by Springer Nature: between 2013 and 2015 more open access articles were reported to the Open APC initiative than the publisher registered with an open license via Crossref (see Figure 2). 



![](../img/oapc_cr_springer.png)
*Figure 2: Comparing Springer Nature hybrid open access journal articles available via Crossref with  disclosed spending information via the Open APC initiative.*

## Discussion and conclusion

This dashboard demonstrates the uptake of hybrid open access publishing for a sample of journals where institutional support facilitated the open access publication of individual articles, and where licensing metadata about the open access status were made available via Crossref. Such study design implements recent proposals to keep track of the transition of subscription-based journal publishing to open access including ESAC’s recommendations for article workflows and services for offsetting / open access transformation agreements [@Geschuhn_2017]. 

Findings are consistent with earlier studies, confirming the growth of hybrid open access publishing. @Laakso_2016 observed a general increase of hybrid opena ccess publishing. They identified 13994 hybrid open access articles that were published in 2714 different journals during 2013. @Bj_rk_2017 reports an increase of hybrid open access articles  since 2014, presumably because centralized funding and aggrements with major publishers. In a recent study also using Crossref metadata, however, @Piwowar_2017 report a much higher share of hybrid open access articles published in 2015 according to which 9,4 % of all journals articles published in this year were provided as hybrid open access. The share of open access, which was free to read on publisher websites, but where the journal was neither listed in the DOAJ nor provided a license was even higher (17,6 %), raising important questions about how to increase standards to discover publisher-driven open access.

Likewise, not all publishers examined shared licensing metadata, although Crossref supports publishers who wish to make licensing metadata available via the Crossref APIs:
<https://support.crossref.org/hc/en-us/articles/214572423-License-metadata-Access-Indicators->
As a publisher to be best represented in our tudy design, publishers need to make sure to include license URL element `license_ref` and a `start_date` equal to the date of publication. 

Overall findings suggest a gap between spending information available through the Open APC initiative and the total number of hybrid open access articles that have been registered with   Crossref in recent years. A likely reason is that reporting to the Open APC initiative is voluntary [@Jahn_2016]. Therefore, not all institutions contribute cost data or information about central aggrements to this initiative. It is also hard to keep track of already exisiting cost data, which were made openly availabe outside the Open APC initiative because no standardized practise to publish and share these datasets exists. Additionally, not all open access publication were sponsored by institutions, but authors can make use of other resources to publish open access, or fees are waived [@Solomon_2011].

Besides the empirical findings, in using open data sources and tools to analyse and present these data, this dashboard demonstrates how monitoring of hybrid open access monitoring can become more transparent and reproducible. Particularly,  the [rcrossref](https://github.com/ropensci/rcrossref) client, developed and maintained by the [rOpenSci initiative](https://ropensci.org/), makes it easy to implement comprehensive API requests needed to query Crossref API for hybrid open access journal articles and article volume. Future work will evaluate our retrieval strategy in terms of precision and recall, and how it can be improved in terms of excluding delayed open access and identifying open licenses. 

## Meta

### How to contribute?

This dashboard has been developed in the open using open tools. There are a number of ways you can help make the dashboard better:

- If you don’t understand something, please let me know and [submit an issue](https://github.com/subugoe/hybrid_oa_dashboard/issues).

- Feel free to add new features or fix bugs by sending a [pull request](https://github.com/subugoe/hybrid_oa_dashboard/pulls).

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/subugoe/hybrid_oa_dashboard/CONDUCT.md). By participating in this project you agree to abide by its terms.

Author: Najko Jahn (Scholarly Communication Analyst, [SUB Göttingen](https://www.sub.uni-goettingen.de/)), 2017.

The R Markdown file, which includes the underlying source code for this document, is available [here](https://github.com/njahn82/hybrid_oa_dashboard/blob/master/docs/about.Rmd).

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

## Bibliography
