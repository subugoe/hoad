---
title: "Comparing the indexing coverage of SpringerLink with that of Crossref"
author: "Najko Jahn"
output:
  html_document:
    keep_md: true
    df_print: paged
---



In its [blog post](https://www.intact-project.org/general/openapc/2018/03/22/offsetting-coverage/), the INTACT project compares the indexing coverage of Crossref, a DOI registration agency for scholarly works, with that of SpringerLink, a digital library dedicated to content published by Springer. Examining five journals including European Radiology, they found that the article coverage differs between these two sources and concluded:

> The results are clear: When it comes to journal metrics (both OA and total), Crossref data is too sketchy to rely on.

This is very harsh given the importance of Crossref to [study the prevalence of open access](https://peerj.com/articles/4375/) and for [open access monitoring](http://www.knowledge-exchange.info/event/oa-monitoring). So, let's examine whether we come to the same conclusion. 

## Analyses

To do so, I firstly downloaded the yearly article volume from the journal [European Radiology](http://www.springer.com/medicine/radiology/journal/330) from SpringerLink, starting in 2015.

Let's load these metadata into R and obtain information about when and in which volumes articles were published:



```r
library(tidyverse)
my_files <- list.files(pattern = ".csv")
springer <- purrr::map_df(my_files, readr::read_csv)
springer %>%
  count(`Publication Year`, `Journal Volume`)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Publication Year"],"name":[1],"type":["int"],"align":["right"]},{"label":["Journal Volume"],"name":[2],"type":["chr"],"align":["left"]},{"label":["n"],"name":[3],"type":["int"],"align":["right"]}],"data":[{"1":"2015","2":"25","3":"426"},{"1":"2016","2":"26","3":"527"},{"1":"2017","2":"27","3":"596"},{"1":"2017","2":"NA","3":"55"},{"1":"2018","2":"28","3":"199"},{"1":"2018","2":"NA","3":"160"},{"1":"NA","2":"1 / 1991 - 28 / 2018","3":"4"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Four records seem to represent journal information. There are also online-first articles published in 2017 and 2018, which have not appeared in a printed volume, yet. 

Now, let's obtain metadata via the [Crossref API](https://api.crossref.org/) using the [rcrossref package](https://github.com/ropensci/rcrossref), and check whether Crossref's and SpringerLink's indexing coverage of articles published in European Radiology 2015 and 2016 is identical. For this aim, we firstly used the `from-pub-date` parameter as the INTACT study did, and secondly, the `from-print-pub-date` parameter was used to avoid confusion between online-first and print publication. 


```r
library(rcrossref)
# R call representing from-pub-date query
cr_from_online <- rcrossref::cr_works(filter = c(issn = "0938-7994", 
                                        from_pub_date = "2015-01-01", 
                                        until_pub_date = "2016-12-31",
                                        type = "journal-article"),
                             limit = 1000, cursor = "*", cursor_max = 5)

# R call representing from-print-pub-date query
cr_from_print <- rcrossref::cr_works(filter = c(issn = "0938-7994", 
                                        from_print_pub_date = "2015-01-01", 
                                        until_print_pub_date = "2016-12-31",
                                        type = "journal-article"),
                             limit = 1000, cursor = "*", cursor_max = 5)
```

Are there different result sets?

Dataset obtained from querying by first date of publication:


```r
cr_from_online$data %>% 
  count(volume)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["volume"],"name":[1],"type":["chr"],"align":["left"]},{"label":["n"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"25","2":"230"},{"1":"26","2":"489"},{"1":"27","2":"281"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Dataset obtained from querying by date of publication in a printed volume:


```r
cr_from_print$data %>% 
    count(volume)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["volume"],"name":[1],"type":["chr"],"align":["left"]},{"label":["n"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"25","2":"426"},{"1":"26","2":"527"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

While articles queried by `from-published-date` were published in three different yearly volumes, filtering with `from_print_pub_date` results in an identical number of articles obtained via SpringerLink.

Finally, let's check whether the SpringerLink 2015-2016 and Crossref `from_print_pub_date` sets are equal using DOIs: 


```r
# filter 2015 and 2016 publications
springer_15_16 <- springer %>%
  filter(`Publication Year` %in% c(2015, 2016))
setequal(springer_15_16$`Item DOI`, cr_from_print$data$DOI)
```

```
## [1] TRUE
```

## Conclusion

In conclusion, by checking Crossref and SpringerLink for articles published in "European Radiology" no article coverage differences could be found between these two sources. However, when comparing the indexing coverage of Crossref and SpringerLink, query parameters must be harmonized in order to guarantee equal article sets.

## Session info


```r
sessionInfo()
```

```
## R version 3.4.3 (2017-11-30)
## Platform: x86_64-apple-darwin15.6.0 (64-bit)
## Running under: OS X El Capitan 10.11.6
## 
## Matrix products: default
## BLAS: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRblas.0.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] de_DE.UTF-8/de_DE.UTF-8/de_DE.UTF-8/C/de_DE.UTF-8/de_DE.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] bindrcpp_0.2    rcrossref_0.8.0 forcats_0.2.0   stringr_1.3.0  
##  [5] dplyr_0.7.4     purrr_0.2.4     readr_1.1.1     tidyr_0.8.0    
##  [9] tibble_1.4.2    ggplot2_2.2.1   tidyverse_1.2.1
## 
## loaded via a namespace (and not attached):
##  [1] reshape2_1.4.2   haven_1.1.0      lattice_0.20-35  colorspace_1.3-2
##  [5] miniUI_0.1.1     htmltools_0.3.6  yaml_2.1.18      rlang_0.2.0     
##  [9] pillar_1.1.0     foreign_0.8-69   glue_1.2.0       modelr_0.1.1    
## [13] readxl_1.0.0     bindr_0.1        plyr_1.8.4       munsell_0.4.3   
## [17] gtable_0.2.0     cellranger_1.1.0 rvest_0.3.2      codetools_0.2-15
## [21] psych_1.7.5      evaluate_0.10.1  knitr_1.20       httpuv_1.3.5    
## [25] curl_3.1         parallel_3.4.3   triebeard_0.3.0  urltools_1.7.0  
## [29] broom_0.4.2      Rcpp_0.12.16     xtable_1.8-2     scales_0.5.0    
## [33] backports_1.1.2  jsonlite_1.5     mime_0.5         mnormt_1.5-5    
## [37] hms_0.3          digest_0.6.12    stringi_1.1.7    shiny_1.0.5     
## [41] grid_3.4.3       rprojroot_1.3-2  bibtex_0.4.2     cli_1.0.0       
## [45] tools_3.4.3      magrittr_1.5     lazyeval_0.2.1   crul_0.5.0      
## [49] crayon_1.3.4     pkgconfig_2.0.1  xml2_1.2.0       lubridate_1.7.1 
## [53] assertthat_0.2.0 rmarkdown_1.9.4  httr_1.3.1       rstudioapi_0.7  
## [57] R6_2.2.2         nlme_3.1-131     compiler_3.4.3
```
