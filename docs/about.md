---
title: "About the Hybrid OA Dashboard"
output:
  html_document:
    df_print: paged
    keep_md: yes
    toc: yes
    toc_depth: 2
    toc_float: yes
bibliography: references.bib
---





## Summary 

[This open source dashboard](https://najkoja.shinyapps.io/hybridoa/) presents the uptake of hybrid open access for 2,919 different journals from 31 publishers between 2013 - 2017. During this five years period, 86,639 articles were made openly available immediately in these subscription-based journals, representing 2.4% of the total article volume studied.

Hybrid open access journals are included when they meet the following two conditions:

1. academic institutions sponsored the publication fee or enabled open access publication through an offsetting agreement according to the [Open APC initiative](https://github.com/openapc/openapc-de),
2. publishers shared licensing information about fulltext accessibility and re-use rights with  [Crossref](https://www.crossref.org/).

By bringing together openly available datasets about hybrid open access into one easy-to-use tool, this dashboard demonstrates how existing pieces of an evolving and freely available data infrastructure for monitoring scholarly publishing can be re-used to gain a better understanding of hybrid open access publishing. It, thus, contributes to recent calls from the [Open Access 2020 Initiative](https://oa2020.org/) and [Open Knowledge](https://blog.okfn.org/2017/10/24/understanding-the-costs-of-scholarly-publishing-why-we-need-a-public-data-infrastructure-of-publishing-costs/) aiming at a data-driven debate about how to transition subscription-based journal publishing to open access.

This document gives information about the study design, as well as how to use the dashboard. Because this open source dashboard was built around already existing infrastructure services for scholarly publishing, discussion will also include guidance about how publishers can properly report hybrid open access journal articles to Crossref in accordance with evolving standards like the [ESAC guidelines](http://esac-initiative.org/its-the-workflows-stupid-what-is-required-to-make-offsetting-work-for-the-open-access-transition/).

## Data and methods 

Many publishers offer hybrid open access journals [@Suber_2012]. However, because of non-standardised reporting practices, it is hard to keep track of how many articles were provided immediately in open access by these journals, and to what extent these figures relate to the overall article volume published [@Bj_rk_2017]. In particular, it is challenging to determine subscription-based journals that already did publish open access articles, as well as to obtain proper licensing information about access and re-use rights [@Laakso_2016; @Piwowar_2017].

To reflect the challenge of finding hybrid open access journals with published open access articles, we started with a sample of hybrid open access journals from the [Open APC initiative](https://github.com/OpenAPC/openapc-de/). This open data initiative crowd-source information about spending on open access journal articles from various international research organisations. [Its openly available dataset](https://github.com/OpenAPC/openapc-de/blob/master/data/apc_de.csv) differentiates expenditure for articles published in hybrid and in fully open access journals. It also has a dedicated dataset containing information about articles, which were made openly available as part of [offsetting deals](https://github.com/OpenAPC/openapc-de/tree/master/data/offsetting), central agreements between publishers and large research organisations or consortia aiming at transitioning subscription-based licensing to open access business models. Using data from the [Open APC initiative](https://github.com/OpenAPC/openapc-de/), thus, ensured that only hybrid open access journals with at least one centrally funded open access article were examined.

After obtaining data about hybrid open access journals from the Open APC initiative, [Crossref's REST API](https://github.com/CrossRef/rest-api-doc) was queried to discover open access articles published in these journals, as well as to retrieve yearly article volumes for the period 2013 - 2017. Using the [rcrossref](https://github.com/ropensci/rcrossref) client, developed and maintained by the [rOpenSci initiative](https://ropensci.org/), the first API call retrieved all licenses URLs available per ISSN. To control developements of the publishing market resulting in name changes of publishers or journal titles over time, only the most frequent facet field name was used. After matching and normalizing  licensing URLs indicating open access articles with the help of the [dissem.in / oaDOI access indicator list](https://github.com/dissemin/dissemin/blob/0aa00972eb13a6a59e1bc04b303cdcab9189406a/backend/crossref.py#L89), a second API call checked licensing metadata to exclude delayed open access articles by using the [Crossref's REST API filters](https://github.com/CrossRef/rest-api-doc#filter-names) `license.url` and `license.delay` for the every single year in period of 2013 - 2017. Because journal business models can change from hybrid to fully open access over time, the [Directory of Open Access Journals (DOAJ)](https://doaj.org/), a curated list of fully open access journals, was finally checked to exclude these journals. 

Notice that although Crossref covers most open access journals disclosed by the Open APC initiative, not all publishers shared comprehensive metadata about access and re-use including licenses and embargo date via Crossref. In our case, 31 publishers provided licensing
metadata via the Crossref API, representing 22 % of all publishers studied. At the journal-level, 72 % of all hybrid open access journal titles covered by the Open APC initiative shared proper licensing metadata with Crossref. Figure 1 provides a breakdown of licencing metadata coverage per publisher.




![](../img/licensing_coverage.png)

*Figure: Overview of Crossref licensing coverage per publisher. Yellow dots represent the number of hybrid open access journals disclosed by the Open APC initiative with licensing metadata, blue dots the overall number of hybrid open access journals in our sample.*

Data were gathered on 2017-11-28. Methods were implemented in R and were made openly available in the source code repository of this project hosted on [GitHub](https://github.com/subugoe/hybrid_oa_dashboard) together with the compiled datasets. A [Shiny web application](https://shiny.rstudio.com/) was built to present the results using [flexdashboard](http://rmarkdown.rstudio.com/flexdashboard/) package. The app is powered by the graphic packages [plotly](https://github.com/ropensci/plotly), [ggplot2](http://ggplot2.tidyverse.org/) and [ggalt](https://github.com/hrbrmstr/ggalt), as well as  [readr](http://readr.tidyverse.org/) for data import. Data analysis made use of [dplyr](http://dplyr.tidyverse.org/).


## Results 

Using data from Open APC and Crossref, we found 86,639  open access articles published in
2,919 subscription-based journals from 31 publishers between 2013 - 2017. These articles accounted for about 2.4% of the overall journal article volume investigated.

Results at the publisher and journal level are accessible and browsable through an [interactive dashboard using dynamic graphs](https://najkoja.shinyapps.io/hybridoa/). Launching the app shows up the overall results that can be subsetted by publisher or journal via the select boxes in the left sidebar. Publisher names are decreasingly sorted according to the number of hybrid open access articles published. Corresponding journals are filtered conditionally to the publisher selection and are sorted alphabetically.

![*Figure 2: Screenshot of the Hybrid OA Dashboard available at <https://najkoja.shinyapps.io/hybridoa/>*](../img/screenshot.png)

### Hybrid OA uptake

The upper part of the dashboard allows to explore the annual development of hybrid open access publishing between 2013 - 2017. The first tab shows the relative uptake of hybrid open access, the second tab the absolute number of published hybrid open access articles on a yearly basis. Bar charts are sub-grouped according to the licensing links found via Crossref. Overall results indicate that the number and proportion of hybrid open access journal articles rose between 2013 (3,898 articles, OA share: 0.58 %) and 2017  (32,208 articles, OA share: 4.3 %).




Table 1 presents an additional breakdown by publishers, contrasting the number of journals with the number of articles found. The three publishers Elsevier BV, Springer Nature and Wiley-Blackwell are leading, accounting for the largest proportion of hybrid open access journals (93 %) and open access articles (84 %) found.


<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Publisher"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Journals (in %)"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Article volume (in %)"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Hybrid OA article volume"],"name":[4],"type":["int"],"align":["right"]},{"label":["OA proportion per publisher (in %)"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Overall OA proportion (in %)"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"Elsevier BV","2":"877 (30.03 %)","3":"1751502 (48.84 %)","4":"38347","5":"2.19","6":"44.26"},{"1":"Springer Nature","2":"1401 (47.98 %)","3":"742375 (20.7 %)","4":"26335","5":"3.55","6":"30.40"},{"1":"Wiley-Blackwell","2":"430 (14.73 %)","3":"517049 (14.42 %)","4":"8405","5":"1.63","6":"9.70"},{"1":"American Chemical Society (ACS)","2":"45 (1.54 %)","3":"204975 (5.72 %)","4":"4318","5":"2.11","6":"4.98"},{"1":"Institute of Electrical and Electronics Engineers (IEEE)","2":"33 (1.13 %)","3":"75422 (2.1 %)","4":"66","5":"0.09","6":"0.08"},{"1":"American Physical Society (APS)","2":"5 (0.17 %)","3":"70997 (1.98 %)","4":"1151","5":"1.62","6":"1.33"},{"1":"AIP Publishing","2":"6 (0.21 %)","3":"64005 (1.78 %)","4":"359","5":"0.56","6":"0.41"},{"1":"IOP Publishing","2":"32 (1.1 %)","3":"55140 (1.54 %)","4":"3342","5":"6.06","6":"3.86"},{"1":"Acoustical Society of America (ASA)","2":"1 (0.03 %)","3":"17537 (0.49 %)","4":"1","5":"0.01","6":"0.00"},{"1":"American Psychological Association (APA)","2":"16 (0.55 %)","3":"11360 (0.32 %)","4":"79","5":"0.70","6":"0.09"},{"1":"American Meteorological Society","2":"6 (0.21 %)","3":"8230 (0.23 %)","4":"41","5":"0.50","6":"0.05"},{"1":"The Company of Biologists","2":"3 (0.1 %)","3":"7978 (0.22 %)","4":"167","5":"2.09","6":"0.19"},{"1":"International Union of Crystallography (IUCr)","2":"7 (0.24 %)","3":"7374 (0.21 %)","4":"1162","5":"15.76","6":"1.34"},{"1":"S. Karger AG","2":"18 (0.62 %)","3":"6888 (0.19 %)","4":"394","5":"5.72","6":"0.45"},{"1":"Japan Society of Applied Physics","2":"1 (0.03 %)","3":"6861 (0.19 %)","4":"40","5":"0.58","6":"0.05"},{"1":"The Royal Society","2":"5 (0.17 %)","3":"6450 (0.18 %)","4":"20","5":"0.31","6":"0.02"},{"1":"Association for Research in Vision and Ophthalmology (ARVO)","2":"2 (0.07 %)","3":"4749 (0.13 %)","4":"1817","5":"38.26","6":"2.10"},{"1":"American Dairy Science Association","2":"1 (0.03 %)","3":"4489 (0.13 %)","4":"186","5":"4.14","6":"0.21"},{"1":"Portland Press Ltd.","2":"4 (0.14 %)","3":"3912 (0.11 %)","4":"126","5":"3.22","6":"0.15"},{"1":"Rockefeller University Press","2":"2 (0.07 %)","3":"3400 (0.09 %)","4":"60","5":"1.76","6":"0.07"},{"1":"American Vacuum Society","2":"2 (0.07 %)","3":"2632 (0.07 %)","4":"26","5":"0.99","6":"0.03"},{"1":"Oxford University Press (OUP)","2":"4 (0.14 %)","3":"2127 (0.06 %)","4":"55","5":"2.59","6":"0.06"},{"1":"Informa UK Limited","2":"2 (0.07 %)","3":"2021 (0.06 %)","4":"2","5":"0.10","6":"0.00"},{"1":"American Association of Pharmaceutical Scientists (AAPS)","2":"2 (0.07 %)","3":"1717 (0.05 %)","4":"55","5":"3.20","6":"0.06"},{"1":"Walter de Gruyter GmbH","2":"6 (0.21 %)","3":"1691 (0.05 %)","4":"36","5":"2.13","6":"0.04"},{"1":"The Optical Society","2":"1 (0.03 %)","3":"1590 (0.04 %)","4":"1","5":"0.06","6":"0.00"},{"1":"SAGE Publications","2":"2 (0.07 %)","3":"1490 (0.04 %)","4":"8","5":"0.54","6":"0.01"},{"1":"Cambridge University Press (CUP)","2":"2 (0.07 %)","3":"922 (0.03 %)","4":"17","5":"1.84","6":"0.02"},{"1":"American Speech Language Hearing Association","2":"1 (0.03 %)","3":"902 (0.03 %)","4":"12","5":"1.33","6":"0.01"},{"1":"Springer Fachmedien Wiesbaden GmbH","2":"2 (0.07 %)","3":"510 (0.01 %)","4":"8","5":"1.57","6":"0.01"},{"1":"Nomos Verlag","2":"1 (0.03 %)","3":"229 (0.01 %)","4":"3","5":"1.31","6":"0.00"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

*Table 1: Hybrid open access journal and article breakdown by publisher.*



Numbers and proportion of hybrid open access journal articles varies across publishers and journals. In the year 2016, for example, the mean open access proportion per Springer Nature journal was 9.2 % (SD = 7.1 %), whereas the  mean open access articles proportion per journal published by Elsevier BV was 2.2 % (SD = 2.2 %). Figure 3 shows the variations for the five publishers with the largest number of hybrid open access journals in 2016 according to our data.



![](../img/oa_variation.png)

*Figure 3: Box plot characterizing spread and differences of the share of open access articles provided by subscription-based journal per publisher in 2016 using five summary statistics (the median, the 25th and 75th percentiles, and 1.5 times the inter-quartile range between the first and third quartiles), and visualizing all outlying points individually.*

### Institutional support

In addition to bibliographic metadata, institutional support either for publication fees or as part of central agreements between research organisations and publishers (offsetting) was also studied.
The lower left chart in the dashboard compares the number of articles found via Open APC and Crossref for the selection. The lower right chart indicates from which countries the institutional support originated from. 

Notice that it is very likely that the overall decrease of spending for hybrid open access reported to the Open APC initiative in 2017 is due to a lag between the time that payments were made and expenditures were reported to the initiative. Comparing the number of articles found via Open APC and Crossref, furthermore suggests that not all publishers share licensing metadata retrospectively. Take for instance journals published by Springer Nature: between 2013 and 2015 more open access articles were reported to the Open APC initiative than registered with an open license via Crossref (see Figure 2). 



![](../img/oapc_cr_springer.png)
*Figure 2: Comparing Springer Nature hybrid open access journal articles available via Crossref with  disclosed spending information via the Open APC initiative.*


## Discussion and conclusion

This dashboard demonstrates the uptake of hybrid open access publishing for a sample of subscription-based journals where institutional support facilitated the open access publication of individual articles, and where licensing metadata about the open access status were made available via Crossref. In using open data sources and tools to analyse and present these data, this dashboard demonstrates how monitoring of hybrid open access can become more transparent and reproducible.

The presented longitudinal findings are consistent with earlier studies, confirming the growth of hybrid open access publishing. According to @Laakso_2016 hybrid open access publishing increased between 2007 - 2013. The authors identified 13,994 hybrid open access articles published in 2,714 different journals during 2013. @Bj_rk_2017 also observed an increase since 2014, presumably because of  centralized agreements with large publishers. Notably Springer Nature has started to offer offsetting deals to large research organisations like the Max Planck Society and national consortia since then [@Geschuhn_2017]. But also recent funding policies in favor of hybrid open access, notably in the UK, likely influenced the uptake of hybrid open access publishing [@Pinfield_2017].

While our findings confirm the uptake of hybrid open access in recent years, related studies observed higher proportions of freely available articles in hybrid open access journals. Studying subscription-based journals with at least one identified hybrid open access article as well, @Laakso_2016 determined an open access share of 3.8 % for the period of 2011–2013. Using Crossref metadata, @Piwowar_2017 estimated an even higher proportion according to which 9.4 % of articles published in 2015 were provided as hybrid open access. Our future work will, therefore, focus on evaluation our retrieval strategy in terms of precision and recall in order to better understand these differences. 

@Piwowar_2017 also found that the percentage of open access provided by publishers, which was free to read, but where the journal was neither listed in the DOAJ nor provided licensing metadata, was even higher (17.6 %). Our study confirms that metadata workflows for hybrid open access publishing as suggested by initiatives like [ESAC](http://esac-initiative.org/) are not comprehensively implemented, yet. Only every fifth publisher in our sample shared licensing metadata via Crossref. In addition to this incomplete licensing coverage, our findings also suggest a gap between spending information available through the Open APC initiative and the total number of hybrid open access articles that have been registered with Crossref in recent years. A likely reason is that reporting to the Open APC initiative is voluntary [@Jahn_2016]. Therefore, presumably not all institutions contribute cost data or information about central aggrements to this initiative. However, not all hybrid open access articles were sponsored by institutions, but authors can make use of other resources to publish open access, or fees are waived [@Solomon_2011]. 

As institutional support of hybrid open access journals grows, the overall aim of this dashboard is to promote evolving standards and infrastructures for analyzing the transition of subscription-based journal publishing to open access. Crossref provides excellent guidance for publishers to make licensing metadata available via the Crossref APIs:
<https://support.crossref.org/hc/en-us/articles/214572423-License-metadata-Access-Indicators->. For being best represented in this dashboard, publishers will have to make sure to include license URL element `license_ref` and a `start_date` equal to the date of publication in the licensing metadata, which helps to identify open access journal content as well as to differentiate between immediate and delayed open access. Likewise, research institutions, funders, and libraries can increase transparency about hybrid open access publishing including offsetting deals by reporting funded articles to the Open APC initiative on a regular basis. Both practices comply with [ESAC's recommendation for article workflows and services for offsetting/ open access transformation agreements](http://esac-initiative.org/its-the-workflows-stupid-what-is-required-to-make-offsettin) . Following these guidelines will help to extend existing methods and data sources to monitor the transition of subscription-based journal publishing to open access in an open and transparent way.

## Meta

### How to contribute?

Dashboard and analysis have been developed in the open using open tools. There are a number of ways you can help make the this work better:

- If you don’t understand something, please let me know and [submit an issue](https://github.com/subugoe/hybrid_oa_dashboard/issues).

- Feel free to add new features or fix bugs by sending a [pull request](https://github.com/subugoe/hybrid_oa_dashboard/pulls).

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/subugoe/hybrid_oa_dashboard/CONDUCT.md). By participating in this project you agree to abide by its terms.

Author: Najko Jahn (Scholarly Communication Analyst, [SUB Göttingen](https://www.sub.uni-goettingen.de/)), 2017.

The R Markdown file, which includes the underlying source code for this document, is available [here](https://github.com/njahn82/hybrid_oa_dashboard/blob/master/docs/about.Rmd).

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

## Bibliography