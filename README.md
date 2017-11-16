# A reproducible dashboard for monitoring hybrid open acccess uptake with R

Source code and data repository for the hybrid open access dashboard, using [flexdashboard](https://rstudio.github.io/flexdashboard) and [shiny](http://shiny.rstudio.com).

A live demo is available here:

<https://najkoja.shinyapps.io/hybridoa/>

![](img/screenshot.png)

## Requirements

```r
install.packages(c("flexdashboard", "dplyr", "readr", "plotly", "scales", "ggalt"), dependencies = TRUE)
```

## Running the dashboard locally

```r
rmarkdown::run("dashboard.Rmd")
```

## Methods and data

Methods used are available in the R folder. [`R/cr_fetching.R`](R/cr_fetching.R) describes how licensing and journal metadata were obtained from [Crossref](https://www.crossref.org/), using the [rcrossref](https://github.com/ropensci/rcrossref) client, developed and maintained by the rOpenSci initiative (https://ropensci.org/). [`R/oapc.R`](R/oapc.R) shows how cost information was analysed. 

For a long-form documentation, see [about.md](about.md)

### Data

Data files stored in the [data/](data/) folder include:

#### Indicator dataset

[data/hybrid_license_indicators.json](data/hybrid_license_indicators.json) and [data/hybrid_license_indicators.csv](data/hybrid_license_indicators.csv)

containing the following variables:

|Variable            |Description
|:-------------------|:------------------------------------------------------------------|
|`journal_title`     |Journal Title                                                      |
|`publisher`         |Publisher Name                                                     |
|`issn`              |ISSN                                                               |
|`year`              |Publishing year                                                    |
|`license`           |Open License URL                                                   |
|`jn_published`      |Yearly article volume per journal                                  |
|`year_all`          |Yearly article volume of all journals in the dataset               |
|`year_publisher_all`|Yearly article volume of all journals in the dataset per publisher |                              |
|`license_ref_n`     |Yearly article volume under the license `license`                  |


#### Licensing metadata

[data/jn_facets_df.json](data/jn_facets_df.json) contains journal article volume and corresponding licensing information for the period  2013 - 2017 for each ISSN found in the Open APC dataset representing a hybrid OA journal.

[data/hybrid_license_df.json](data/jn_facets_df.json) stores information about journals with licensing metadata representing hybrid OA journal articles (excluding delayed OA and licenses that only govern text mining)

## How to contribute?

This dashboard has been developed in the open using open tools. There are a number of ways you can help make the dashboard better:

- If you don’t understand something, please let me know and submit an issue.

- Feel free to add new features or fix bugs by sending a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

## Meta

License: MIT
