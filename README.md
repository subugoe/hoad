<!-- badges: start -->
[![Main](https://github.com/subugoe/hoad/workflows/.github/workflows/main.yaml/badge.svg)](https://github.com/subugoe/hoad/actions)
[![Codecov test coverage](https://codecov.io/gh/subugoe/hoad/branch/master/graph/badge.svg?token=rbmMyt4C1L)](https://codecov.io/gh/subugoe/hoad)
[![CRAN status](https://www.r-pkg.org/badges/version/hoad)](https://CRAN.R-project.org/package=hoad)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
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
      Sign up to the newsletter (german only)
    </a>
  </p>
</div>

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
