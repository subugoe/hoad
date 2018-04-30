

# Datasets

## Hybrid Open Access Article Dataset

#### [`hybrid_publications.csv`](hybrid_publications.csv) 

[`hybrid_publications.csv`](hybrid_publications.csv) contains hybrid open access articles found via Crossref, information about the overall publication volume, and, if available, cost information from the Open APC Initiative.

Documentation:

|Variable                   |Description
|:--------------------------|:------------------------------------------------------------------|
|`license`                  |Open License URI (semi-normalised)                                 |
|`journal_title`            |Most frequent journal title used by Crossref                       |
|`publisher`                |Most frequent publisher name used by Crossref                      |
|`doi_oa`                   |DOI of the hybrid open access article                              |
|`issued`                   |Earliest publication year                                          |            
|`yearly_jn_volume`         |Yearly article volume per journal                                  |
|`license_ref_n`            |Yearly article volume under the license `license`                  |
|`yearly_publisher_volume`  |Yearly article volume of all journals in the dataset per publisher |
|`yearly_all`               |Yearly article volume investigated                                 |
|`institution`              |Top-level organisation which reported article to Open APC          |
|`country`                  |Country of origin (iso3c)                                          |
|`country_name`             |Country of origin (name)                                           |
|`period`                   |Year of reporting to Open APC                                      |
|`euro`                     |The amount that was paid in EURO. Includes VAT and additional fees |
|`hybrid_type`              |Open APC hybrid open access collection (individual or offsetting)  |

Tibble view in R:


```r
library(readr)
readr::read_csv("hybrid_publications.csv")
#> # A tibble: 106,446 x 14
#>    license       journal_title  publisher doi_oa   issued yearly_jn_volume
#>    <chr>         <chr>          <chr>     <chr>     <int>            <int>
#>  1 http://creat… Soft Computing Springer… 10.1007…   2016              466
#>  2 http://creat… Soft Computing Springer… 10.1007…   2016              466
#>  3 http://creat… Soft Computing Springer… 10.1007…   2015              428
#>  4 http://creat… Soft Computing Springer… 10.1007…   2015              428
#>  5 http://creat… Soft Computing Springer… 10.1007…   2017              505
#>  6 http://creat… Soft Computing Springer… 10.1007…   2017              505
#>  7 http://creat… Soft Computing Springer… 10.1007…   2015              428
#>  8 http://creat… Soft Computing Springer… 10.1007…   2016              466
#>  9 http://creat… Soft Computing Springer… 10.1007…   2015              428
#> 10 http://creat… Soft Computing Springer… 10.1007…   2017              505
#> # ... with 106,436 more rows, and 8 more variables: license_ref_n <int>,
#> #   yearly_publisher_volume <int>, yearly_all <int>, period <int>,
#> #   euro <dbl>, hybrid_type <chr>, country <chr>, country_name <chr>
```

## Re-used data sources

Open data from the Open APC Initiative and Crossref were used to identify hybrid open access journals, as well as to obtain information about the publication activities of these journals.

### Open APC Initiative

#### [`oapc_hybrid.csv`](oapc_hybrid.csv)

This dataset was obtained from the [Open APC Initiative](https://github.com/openapc/openapc-de) and was used to determine hybrid open access journals. It also includes data about offsetting aggrements, which has no pricing information, as well as country information.

Data schema: <https://github.com/OpenAPC/openapc-de/wiki/schema>

Tibble view in R:


```r
library(readr)
readr::read_csv("oapc_hybrid.csv")
#> # A tibble: 40,532 x 21
#>    institution  period euro  doi     is_hybrid publisher journal_full_tit…
#>    <chr>         <int> <chr> <chr>   <lgl>     <chr>     <chr>            
#>  1 Aberystwyth…   2015 <NA>  10.100… T         Springer… Soft Computing   
#>  2 Aberystwyth…   2016 <NA>  10.100… T         Springer… Geoheritage      
#>  3 Aberystwyth…   2016 <NA>  10.100… T         Springer… Studies in Philo…
#>  4 Aberystwyth…   2016 <NA>  10.100… T         Springer… Language Policy  
#>  5 Aberystwyth…   2016 <NA>  10.100… T         Springer… Conservation Gen…
#>  6 Aberystwyth…   2016 <NA>  10.100… T         Springer… Sports Medicine  
#>  7 Anglia Rusk…   2016 <NA>  10.100… T         Springer… Journal of Autis…
#>  8 Anglia Rusk…   2016 <NA>  10.100… T         Springer… Experimental Bra…
#>  9 Anglia Rusk…   2016 <NA>  10.100… T         Springer… Morphology       
#> 10 Anglia Rusk…   2016 <NA>  10.100… T         Springer… The Internationa…
#> # ... with 40,522 more rows, and 14 more variables: issn <chr>,
#> #   issn_print <chr>, issn_electronic <chr>, issn_l <chr>,
#> #   license_ref <chr>, indexed_in_crossref <lgl>, pmid <int>, pmcid <chr>,
#> #   ut <chr>, url <chr>, doaj <lgl>, hybrid_type <chr>, country <chr>,
#> #   country_name <chr>
```

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


```r
library(jsonlite)
jsonlite::stream_in(file("jn_facets_df.json"), simplifyDataFrame = FALSE)
```

#### [`hybrid_license_dois.json`](hybrid_license_dois.json)

JSON-ND file documenting articles found for every journal and open license URI.

Variable                    |Description
|:--------------------------|:--------------------------------------------------------------|
|`dois`                     |List fo DOIs                                                   |
|`issn`                     |ISSN obtained from Open APC dataset used to query Crossref API |
|`license`                  |Open License URI (non-normalised)                              |


```r
library(jsonlite)
jsonlite::stream_in(file("hybrid_license_dois.json"), simplifyDataFrame = FALSE)
```

#### `hybrid_license_md.json`

`data/hybrid_license_md.json`contains full metadata of all open access articles found as it was parsed by the `rcrossref::cr_works()` function. Unfortunately, this data file is simply too large to be shared via GitHub. Please contact me, if you want access to it.

Tibble view in R:


```r
library(jsonlite)
library(dplyr)
jsonlite::stream_in(file("../data/hybrid_license_md.json"), verbose = FALSE) %>%
  dplyr::as_data_frame()
#> # A tibble: 114,248 x 36
#>    alternative.id container.title created  deposited DOI    indexed ISSN  
#>  * <chr>          <chr>           <chr>    <chr>     <chr>  <chr>   <chr> 
#>  1 2341           Soft Computing  2016-09… 2017-06-… 10.10… 2017-1… 1432-…
#>  2 2067           Soft Computing  2016-02… 2017-07-… 10.10… 2017-1… 1432-…
#>  3 1801           Soft Computing  2015-07… 2017-06-… 10.10… 2017-1… 1432-…
#>  4 1802           Soft Computing  2015-08… 2017-06-… 10.10… 2017-1… 1432-…
#>  5 2705           Soft Computing  2017-07… 2017-07-… 10.10… 2017-1… 1432-…
#>  6 2738           Soft Computing  2017-07… 2017-07-… 10.10… 2017-1… 1432-…
#>  7 1923           Soft Computing  2015-11… 2017-06-… 10.10… 2017-1… 1432-…
#>  8 2126           Soft Computing  2016-04… 2017-06-… 10.10… 2017-1… 1432-…
#>  9 1913           Soft Computing  2015-11… 2017-06-… 10.10… 2017-1… 1432-…
#> 10 2732           Soft Computing  2017-07… 2017-07-… 10.10… 2017-1… 1432-…
#> # ... with 114,238 more rows, and 29 more variables: issue <chr>,
#> #   issued <chr>, license_date <chr>, license_URL <chr>,
#> #   license_delay.in.days <chr>, license_content.version <chr>,
#> #   member <chr>, page <chr>, prefix <chr>, publisher <chr>,
#> #   reference.count <chr>, score <chr>, source <chr>, subject <chr>,
#> #   title <chr>, type <chr>, update.policy <chr>, URL <chr>, volume <chr>,
#> #   author <list>, link <list>, funder <list>, assertion <list>,
#> #   `clinical-trial-number` <list>, subtitle <chr>, archive <chr>,
#> #   abstract <chr>, archive_ <chr>, NA. <chr>
```

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


```r
library(readr)
readr::read_csv("indicator.csv")
#> # A tibble: 25,953 x 7
#>    journal_title  publisher  year yearly_jn_volume license   license_ref_n
#>    <chr>          <chr>     <int>            <int> <chr>             <int>
#>  1 Soft Computing Springer…  2017              505 http://c…            19
#>  2 Soft Computing Springer…  2016              466 http://c…            15
#>  3 Soft Computing Springer…  2015              428 http://c…            10
#>  4 Soft Computing Springer…  2014              349 <NA>                 NA
#>  5 Soft Computing Springer…  2013              234 <NA>                 NA
#>  6 Soft Computing Springer…  2018              220 http://c…             4
#>  7 Geoheritage    Springer…  2017               65 http://c…             3
#>  8 Geoheritage    Springer…  2016               42 http://c…             2
#>  9 Geoheritage    Springer…  2014               41 <NA>                 NA
#> 10 Geoheritage    Springer…  2015               32 http://c…             2
#> # ... with 25,943 more rows, and 1 more variable:
#> #   yearly_publisher_volume <int>
```

## Flipped journals

To detect fully open acces journals, the [Directory of Open Access Journals](https://doaj.org/) was checked. [`flipped_jns_doaj.csv`](flipped_jns_doaj.csv) contains the so detected articles published in fully open access journals.


```r
library(readr)
readr::read_csv("flipped_jns_doaj.csv")
#> # A tibble: 5,124 x 9
#>    license     journal_title  publisher  doi_oa   issued issn_type.x issn 
#>    <chr>       <chr>          <chr>      <chr>     <int> <chr>       <chr>
#>  1 http://cre… Gynecological… Springer … 10.1186…   2017 issn_2      1613…
#>  2 http://cre… Gynecological… Springer … 10.1186…   2017 issn_2      1613…
#>  3 http://cre… Gynecological… Springer … 10.1186…   2017 issn_2      1613…
#>  4 http://cre… Gynecological… Springer … 10.1186…   2017 issn_2      1613…
#>  5 http://cre… Gynecological… Springer … 10.1186…   2017 issn_2      1613…
#>  6 http://cre… Gynecological… Springer … 10.1186…   2017 issn_2      1613…
#>  7 http://cre… Gynecological… Springer … 10.1186…   2017 issn_2      1613…
#>  8 http://cre… Gynecological… Springer … 10.1186…   2017 issn_2      1613…
#>  9 http://cre… Gynecological… Springer … 10.1186…   2017 issn_2      1613…
#> 10 http://cre… Gynecological… Springer … 10.1186…   2017 issn_2      1613…
#> # ... with 5,114 more rows, and 2 more variables: year_flipped <int>,
#> #   issn_type.y <chr>
```

Furthermore, [`flipped_jns.csv`](flipped_jns.csv) contains journals that are probably flipped, indicated by a proportion of open access article volume larger than 0.95 in at least two years.


```r
library(readr)
readr::read_csv("flipped_jns.csv")
#> # A tibble: 13 x 6
#>    journal_title       publisher        year yearly_jn_volume n_year  prop
#>    <chr>               <chr>           <int>            <int>  <int> <dbl>
#>  1 Electronic Notes i… Elsevier BV      2017               29     29 1.00 
#>  2 Electronic Notes i… Elsevier BV      2018               29     29 1.00 
#>  3 Health Expectations Wiley-Blackwell  2017              127    125 0.984
#>  4 Health Expectations Wiley-Blackwell  2018               34     34 1.00 
#>  5 Integrating Materi… Springer Nature  2013                5      5 1.00 
#>  6 Integrating Materi… Springer Nature  2014               26     25 0.962
#>  7 Integrating Materi… Springer Nature  2016               14     14 1.00 
#>  8 Investigative Opth… Association fo…  2016              929    929 1.00 
#>  9 Investigative Opth… Association fo…  2017              785    785 1.00 
#> 10 Investigative Opth… Association fo…  2018              245    245 1.00 
#> 11 Translational Visi… Association fo…  2016               87     87 1.00 
#> 12 Translational Visi… Association fo…  2017               88     88 1.00 
#> 13 Translational Visi… Association fo…  2018               48     48 1.00
```


## Data re-use and licenses

Datasets are released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or distribute these materials in any form, for any purpose, commercial or non-commercial, and by any means.

Crossref asserts no claims of ownership to individual items of bibliographic metadata and associated Digital Object Identifiers (DOIs) acquired through the use of the Crossref Free Services. Individual items of bibliographic metadata and associated DOIs may be cached and incorporated into the user's content and systems.

Open APC Data are made available under the Open Database License: http://opendatacommons.org/licenses/odbl/1.0/. Any rights in individual contents of the database are licensed under the Database Contents License: http://opendatacommons.org/licenses/dbcl/1.0/.
