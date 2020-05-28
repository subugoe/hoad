# Hybrid Open Access Dashboard (HOAD)

<!-- badges: start -->
[![Main](https://github.com/subugoe/hoad/workflows/.github/workflows/main.yaml/badge.svg)](https://github.com/subugoe/hoad/actions)
[![R CMD check](https://github.com/subugoe/hoad/workflows/R-CMD-check/badge.svg)](https://github.com/subugoe/hoad/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/hoad)](https://CRAN.R-project.org/package=hoad)
[![Codecov test coverage](https://codecov.io/gh/subugoe/hoad/branch/master/graph/badge.svg)](https://codecov.io/gh/subugoe/hoad)
[![Docker Pulls](https://img.shields.io/docker/pulls/subugoe/hoad)](https://hub.docker.com/repository/docker/subugoe/hoad)
<!-- badges: end -->


<div class="jumbotron">
  <h1>Hybrid OA Dashboard</h1>
  <p>
    Bibliometric data analytics to increase cost transparency in hybrid open access transformation contracts.
  </p>
  <p>
    <a class="btn btn-danger btn-lg" href="articles/interactive.html" role="button">
      Try out the dashboard
    </a>
    <a class="btn btn-primary btn-lg" href="newsletter.html" role="button">
      Sign up to the newsletter
    </a>
  </p>
</div>

## Overview

Many academic publishers offer hybrid (hybrid OA) open access journals, where some articles in an otherwise subscription-based publication are made openly available.
Recently, some funders have pushed for a transformation towards such a hybrid OA business model, where publishing houses are paid for open access publication.
To draft, monitor and evaluate such transformative agreements, libraries and their consortia need data on the uptake, costs and impact of hybrid OA.

{HOAD} is a data product to meet this need.
The dashboard is packaged as an extension to the [R Project for Statistical Computing](https://www.r-project.org) (an R package), and released under an open source license.
The project is based on data gathered by the [Crossref](http://www.crossref.org/) DOI registration agency and the [OpenAPC initiative](https://github.com/openapc).


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
