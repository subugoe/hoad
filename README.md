# hoad

<!-- badges: start -->
[![Main](https://github.com/subugoe/hoad/workflows/.github/workflows/main.yaml/badge.svg)](https://github.com/subugoe/hoad/actions)
[![R CMD check](https://github.com/subugoe/hoad/workflows/R-CMD-check/badge.svg)](https://github.com/subugoe/hoad/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/hoad)](https://CRAN.R-project.org/package=hoad)
[![Codecov test coverage](https://codecov.io/gh/subugoe/hoad/branch/master/graph/badge.svg)](https://codecov.io/gh/subugoe/hoad)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test coverage](https://codecov.io/gh/subugoe/hoad/branch/master/graph/badge.svg)](https://codecov.io/gh/subugoe/hoad?branch=master)
<!-- badges: end -->


## Overview

Many academic publishers offer hybrid (hybrid OA) open access journals, where some articles in an otherwise subscription-based publication are made openly available.
Recently, some funders have pushed for a transformation towards such a hybrid OA business model, where publishing houses are paid for open access publication.
To draft, monitor and evaluate such transformative agreements, libraries and their consortia need data on the uptake, costs and impact of hybrid OA.

{HOAD} is a data product to meet this need.
The dashboard is packaged as an extension to the [R Project for Statistical Computing](https://www.r-project.org) (an R package), released under an open source license and developed in the open at http://github.com/subugoe/hoad.
The package has several components:

1. APIs to expose **data** from public bibliometric sources relevant to hybrid OA.
2. **ETL pipelines** (extraction, transformation, loading) and accompanying **visualisations** to answer hybrid OA business questions.
3. A **web application** to explore hybrid OA data, including customisation for individual journal portfolios.

The project is based on data gathered by the [Crossref](http://www.crossref.org/) DOI registration agency and the [OpenAPC initiative](https://github.com/openapc).
The package is at the [Göttingen State and University Libary](https://www.sub.uni-goettingen.de/) as part of the [DFG](https://www.dfg.de)-funded eponymous Hybrid Open Access Dashboard project.

An early prototype of the application, including the interactive web frontend is available at https://subugoe.github.io/hoad/.


## Installation

```r
remotes::install_github("subugoe/hoad")
```


## Getting Started

```r
library(hoad)
```

You can start the dashboard locally, by running `runHOAD()`.

More functions and data will be exposed in the future for modular reuse.
