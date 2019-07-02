

# Datasets

## Hybrid Open Access Article Dataset

#### [`hybrid_publications.csv`](hybrid_publications.csv) 

[`hybrid_publications.csv`](hybrid_publications.csv) contains hybrid open access articles found via Crossref, information about the overall publication volume, and, if available, cost information from the Open APC Initiative.

Documentation:

||Variable                   |Description
|:--------------------------|:------------------------------------------------------------------|
|`license`                  |Normalized open content license statement                          |
|`journal_title`            |Most frequent journal title used by Crossref                       |
|`publisher`                |Most frequent publisher name used by Crossref                      |
|`doi_oa`                   |DOI of the hybrid open access article                              |
|`issued`                   |Earliest publication year                                          |            
|`yearly_jn_volume`         |Yearly article volume per journal                                  |
|`license_ref_n`            |Yearly article volume under the license `license`                  |
|`yearly_publisher_volume`  |Yearly article volume of all journals in the dataset per publisher |
|`yearly_all`               |Yearly article volume investigated                                 |
|`period`                   |Year of reporting to Open APC                                      |
|`euro`                     |The amount that was paid in EURO. Includes VAT and additional fees |
|`hybrid_type`              |Spending source (Open APC, SCOAP3)                                 |
|`institution`              |Top-level organisation which reported article to Open APC          |
|`country`                  |Country of origin (iso3c)                                          |
|`country_name`             |Country of origin (name)                                           |
|`license_url`              |License URL                                                        |
|`host`                     |Email host first or corresponding author                           |
|`subdomain`                |Email subdomain first or corresponding author                      |
|`domain`                   |Email domain first or corresponding author                         |
|`suffix`                   |Email suffix first or corresponding author                         |

Tibble view in R:

library(readr)readr::read_csv("hybrid_publications.csv")#> # A tibble: 207,602 x 20
#>    license journal_title publisher doi_oa issued yearly_jn_volume
#>    <chr>   <chr>         <chr>     <chr>   <int>            <int>
#>  1 cc-by   Soft Computi… Springer… 10.10…   2016              466
#>  2 cc-by   Soft Computi… Springer… 10.10…   2016              466
#>  3 cc-by   Soft Computi… Springer… 10.10…   2016              466
#>  4 cc-by   Soft Computi… Springer… 10.10…   2016              466
#>  5 cc-by   Soft Computi… Springer… 10.10…   2016              466
#>  6 cc-by   Soft Computi… Springer… 10.10…   2016              466
#>  7 cc-by   Soft Computi… Springer… 10.10…   2016              466
#>  8 cc-by   Soft Computi… Springer… 10.10…   2016              466
#>  9 cc-by   Soft Computi… Springer… 10.10…   2016              466
#> 10 cc-by   Soft Computi… Springer… 10.10…   2017              505
#> # … with 207,592 more rows, and 14 more variables: license_ref_n <int>,
#> #   yearly_publisher_volume <int>, yearly_all <int>, institution <chr>,
#> #   period <int>, euro <dbl>, hybrid_type <chr>, country <chr>,
#> #   country_name <chr>, license_url <chr>, host <chr>, subdomain <chr>,
#> #   domain <chr>, suffix <chr>


## Re-used data sources

Open data from the Open APC Initiative and Crossref were used to identify hybrid open access journals, as well as to obtain information about the publication activities of these journals.

### Open APC Initiative

#### [`oapc_hybrid.csv`](oapc_hybrid.csv)

This dataset was obtained from the [Open APC Initiative](https://github.com/openapc/openapc-de) and was used to determine hybrid open access journals. It also includes data about transformative aggrements, which has no pricing information, as well as country information.

Data schema: <https://github.com/OpenAPC/openapc-de/wiki/schema>

Tibble view in R:

library(readr)readr::read_csv("oapc_hybrid.csv")#> # A tibble: 62,960 x 22
#>    institution period euro  doi   is_hybrid publisher journal_full_ti…
#>    <chr>        <int> <chr> <chr> <lgl>     <chr>     <chr>           
#>  1 Aberystwyt…   2015 <NA>  10.1… TRUE      Springer… Soft Computing  
#>  2 Aberystwyt…   2016 <NA>  10.1… TRUE      Springer… Geoheritage     
#>  3 Aberystwyt…   2016 <NA>  10.1… TRUE      Springer… Studies in Phil…
#>  4 Aberystwyt…   2016 <NA>  10.1… TRUE      Springer… Language Policy 
#>  5 Aberystwyt…   2016 <NA>  10.1… TRUE      Springer… Conservation Ge…
#>  6 Aberystwyt…   2016 <NA>  10.1… TRUE      Springer… Sports Medicine 
#>  7 Anglia Rus…   2016 <NA>  10.1… TRUE      Springer… Journal of Auti…
#>  8 Anglia Rus…   2016 <NA>  10.1… TRUE      Springer… Experimental Br…
#>  9 Anglia Rus…   2016 <NA>  10.1… TRUE      Springer… Morphology      
#> 10 Anglia Rus…   2016 <NA>  10.1… TRUE      Springer… The Internation…
#> # … with 62,950 more rows, and 15 more variables: issn <chr>,
#> #   issn_print <chr>, issn_electronic <chr>, issn_l <chr>,
#> #   license_ref <chr>, indexed_in_crossref <lgl>, pmid <int>, pmcid <chr>,
#> #   ut <chr>, url <chr>, doaj <lgl>, agreement <chr>, hybrid_type <chr>,
#> #   country <chr>, country_name <chr>


### Crossref

#### [`jn_facets_df.json`](jn_facets_df.json)

JSON-ND file. Includes the following metadata from Crossref:

|Variable                     |Description                                                        |
|:----------------------------|:------------------------------------------------------------------|
|`issn`                       |ISSNs obtained from Open APC dataset used to query Crossref API    |
|`year_published`             |Lists yearly journal volume obtained from Crossref API facets      |
|`license_refs`               |Obtained Licence URIs                                              |
|`journal_title`              |Most frequent journal title                                        |
|`publisher`                  |Most frequent publisher name                                       |

How to load into R?

library(jsonlite)jsonlite::stream_in(file("jn_facets_df.json"), simplifyDataFrame = FALSE)

#### [`hybrid_license_dois.json`](hybrid_license_dois.json)

JSON-ND file documenting articles found for every journal and open license URI.

Variable                    |Description
|:--------------------------|:--------------------------------------------------------------|
|`dois`                     |List fo DOIs                                                   |
|`issn`                     |ISSN obtained from Open APC dataset used to query Crossref API |
|`license`                  |Open License URI (non-normalised)                              |

library(jsonlite)jsonlite::stream_in(file("hybrid_license_dois.json"), simplifyDataFrame = FALSE)

#### `hybrid_license_md.json`

`data/hybrid_license_md.json`contains full metadata of all open access articles found as it was parsed by the `rcrossref::cr_works()` function. Unfortunately, this data file is simply too large to be shared via GitHub. Please contact me, if you want access to it.

Tibble view in R:

library(jsonlite)library(dplyr)jsonlite::stream_in(file("../data/hybrid_license_md.json"), verbose = FALSE) %>%
  dplyr::as_data_frame()#> # A tibble: 218,621 x 17
#>    container.title created deposited published.print published.online doi  
#>    <chr>           <chr>   <chr>     <chr>           <chr>            <chr>
#>  1 Soft Computing  2016-0… 2017-08-… 2017-09         2016-06-17       10.1…
#>  2 Soft Computing  2016-0… 2017-08-… 2017-09         2016-06-23       10.1…
#>  3 Soft Computing  2016-0… 2016-07-… 2016-08         2016-07-12       10.1…
#>  4 Soft Computing  2016-0… 2017-11-… 2017-12         2016-08-03       10.1…
#>  5 Soft Computing  2016-0… 2017-09-… 2017-10         2016-08-09       10.1…
#>  6 Soft Computing  2016-0… 2017-06-… 2017-01         2016-09-19       10.1…
#>  7 Soft Computing  2016-0… 2017-06-… 2017-01         2016-09-28       10.1…
#>  8 Soft Computing  2016-1… 2017-06-… 2017-01         2016-10-05       10.1…
#>  9 Soft Computing  2016-1… 2017-06-… 2017-01         2016-10-11       10.1…
#> 10 Soft Computing  2016-1… 2018-03-… 2018-03         2016-11-09       10.1…
#> # … with 218,611 more rows, and 11 more variables: indexed <chr>,
#> #   issn <chr>, issued <chr>, member <chr>, publisher <chr>, type <chr>,
#> #   url <chr>, funder <list>, link <list>, license <list>, subject <chr>


## Count data

#### [`indicator.csv`](indicator.csv)

[`indicator.csv`](indicator.csv) contains count data about the examined yearly journal volume. 

Coding scheme:

|Variable                    |Description
|:--------------------------|:------------------------------------------------------------------|
|`journal_title`            |Most frequent journal title used by Crossref                       |
|`publisher`                |Most frequent publisher name used by Crossref                      |
|`year`                     |Earliest publishing year                                           |
|`yearly_jn_volume`         |Yearly article volume per journal                                  |
|`license`                  |Open License URI (semi-normalised)                                 |
|`license_ref_n`            |Yearly article volume under the license `license`                  |
|`yearly_publisher_volume`  |Yearly article volume of all journals in the dataset per publisher |   


Tibble view in R:

library(readr)readr::read_csv("indicator.csv")#> # A tibble: 42,370 x 7
#>    journal_title publisher  year yearly_jn_volume license license_ref_n
#>    <chr>         <chr>     <int>            <int> <chr>           <int>
#>  1 Soft Computi… Springer…  2018              706 http:/…            25
#>  2 Soft Computi… Springer…  2017              505 http:/…            19
#>  3 Soft Computi… Springer…  2019              466 http:/…            12
#>  4 Soft Computi… Springer…  2016              466 http:/…            15
#>  5 Soft Computi… Springer…  2015              428 http:/…            14
#>  6 Soft Computi… Springer…  2014              349 http:/…             1
#>  7 Soft Computi… Springer…  2014              349 http:/…             8
#>  8 Soft Computi… Springer…  2013              234 http:/…             4
#>  9 Geoheritage   Springer…  2017               65 http:/…             3
#> 10 Geoheritage   Springer…  2018               62 http:/…             6
#> # … with 42,360 more rows, and 1 more variable:
#> #   yearly_publisher_volume <int>


## Flipped journals

To detect fully open acces journals, the [Directory of Open Access Journals](https://doaj.org/) was checked. [`flipped_jns_doaj.csv`](flipped_jns_doaj.csv) contains the so detected articles published in fully open access journals.

library(readr)readr::read_csv("flipped_jns_doaj.csv")#> # A tibble: 14,550 x 9
#>    license journal_title publisher dois  issued issn_type.x issn 
#>    <chr>   <chr>         <chr>     <chr>  <int> <chr>       <chr>
#>  1 http:/… Gynecologica… Springer… 10.1…   2017 issn_2      1613…
#>  2 http:/… Gynecologica… Springer… 10.1…   2017 issn_2      1613…
#>  3 http:/… Gynecologica… Springer… 10.1…   2017 issn_2      1613…
#>  4 http:/… Gynecologica… Springer… 10.1…   2017 issn_2      1613…
#>  5 http:/… Gynecologica… Springer… 10.1…   2017 issn_2      1613…
#>  6 http:/… Gynecologica… Springer… 10.1…   2017 issn_2      1613…
#>  7 http:/… Gynecologica… Springer… 10.1…   2017 issn_2      1613…
#>  8 http:/… Gynecologica… Springer… 10.1…   2017 issn_2      1613…
#>  9 http:/… Gynecologica… Springer… 10.1…   2017 issn_2      1613…
#> 10 http:/… Gynecologica… Springer… 10.1…   2017 issn_2      1613…
#> # … with 14,540 more rows, and 2 more variables: year_flipped <int>,
#> #   issn_type.y <chr>


Furthermore, [`flipped_jns.csv`](flipped_jns.csv) contains journals that are probably flipped, indicated by a proportion of open access article volume larger than 0.95 in at least two years.

library(readr)readr::read_csv("flipped_jns.csv")#> # A tibble: 33 x 6
#>    journal_title       publisher        year yearly_jn_volume n_year  prop
#>    <chr>               <chr>           <int>            <int>  <int> <dbl>
#>  1 3 Biotech           Springer Nature  2014               78     77 0.987
#>  2 3 Biotech           Springer Nature  2015               48     47 0.979
#>  3 3 Biotech           Springer Nature  2016              254    253 0.996
#>  4 Applied Nanoscience Springer Nature  2013              104    102 0.981
#>  5 Applied Nanoscience Springer Nature  2014              103    101 0.981
#>  6 Applied Nanoscience Springer Nature  2015              125    125 1    
#>  7 Applied Nanoscience Springer Nature  2016               30     30 1    
#>  8 Applied Nanoscience Springer Nature  2017               89     89 1    
#>  9 EPMA Journal        Springer Nature  2013               25     25 1    
#> 10 EPMA Journal        Springer Nature  2014              187    187 1    
#> # … with 23 more rows



## Data re-use and licenses

Datasets are released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or distribute these materials in any form, for any purpose, commercial or non-commercial, and by any means.

Crossref asserts no claims of ownership to individual items of bibliographic metadata and associated Digital Object Identifiers (DOIs) acquired through the use of the Crossref Free Services. Individual items of bibliographic metadata and associated DOIs may be cached and incorporated into the user's content and systems.

Open APC Data are made available under the Open Database License: http://opendatacommons.org/licenses/odbl/1.0/. Any rights in individual contents of the database are licensed under the Database Contents License: http://opendatacommons.org/licenses/dbcl/1.0/.
