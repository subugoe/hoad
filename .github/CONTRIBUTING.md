# Contributing to the hoad project

This outlines how to propose a change to the hybrid open access dashboard (hoad). 


## Project Structure

Because hoad is not only a research project, but primarily a data product meant to be used by many, hoad is organised as an R package.

Please adhere by the package development best practices laid out in:

- Hadley Wickham's [R Packages](https://r-pkgs.org/index.html)
- [rOpenSci Development Guide](https://devguide.ropensci.org/)


### Documentation

Individual functions are documented using [{roxygen2}](https://roxygen2.r-lib.org).
Functions can be further organised using curated reference index in [{pkgdown}](https://pkgdown.r-lib.org/).

Scientific articles, blog posts or any other long-form documentation is written as a [{pkgdown}](https://pkgdown.r-lib.org/) *article* inside the packages `/vignettes/` folder.
These articles are written as `bookdown::html_document2()` documents *not* as proper R vignettes, to avoid duplicate publication and to allow more expensive computations.


### Shiny Application

tba.


### Computing Environments

There are two sets of computing environments on which this project is guaranteed to work as per the CI setup:

1. The {hoad} package, including all its functions, is guaranteed to work (pass `R CMD check`) on a wide variety of computing environments as per the CI setup, a subset of the [tidyverse setup](https://github.com/r-lib/actions/tree/master/examples#quickstart-ci-workflow) and [r-hub linux builders](https://github.com/r-hub/rhub-linux-builders).
  Because these tests can be quite extensive, they are only run on commits to `master`, as well as pull requests to `master`.
  Other branches are thus not guaranteed to work.
2. All other elements of this projects can be reproduced using a custom docker image in the `Dockerfile`:
    - the [{pkgdown}](http://pkgdown.r-lib.org) website for hoad (https://subugoe.github.io/hoad/), including its articles (~ vignettes)
    - the shiny web application
    - (batch) jobs to reproduce more expensive analyses

    This image is also published on every commit to [docker hub](https://hub.docker.com/repository/docker/subugoe/hoad), tagged by git sha and reference (branch, release).
  
    This image also includes the RStudio IDE, so you can also develop *inside* this image. 

    To run this image, navigate your shell to the root of the repository on your machine and run:

    ```
    docker run --env DISABLE_AUTH=true \
      --publish 8787:8787 \
      --volume $(pwd):/home/rstudio/Documents 
      subugoe/hoad:refactor-as-pkg
    ```
   
    This will automatically download the build image from Docker Hub.
    You can also rebuild it locally by running
    
    ```
    docker build --tag hoad .
    ```

## Fixing typos

You can fix typos, spelling mistakes, or grammatical errors in the documentation directly using the GitHub web interface, as long as the changes are made in the _source_ file. 
This generally means you'll need to edit [roxygen2 comments](https://roxygen2.r-lib.org/articles/roxygen2.html) in an `.R`, not a `.Rd` file. 
You can find the `.R` file that generates the `.Rd` by reading the comment in the first line.

## Bigger changes

If you want to make a bigger change, it's a good idea to first file an issue and make sure someone from the team agrees that it’s needed. 
If you’ve found a bug, please file an issue that illustrates the bug with a minimal 
[reprex](https://www.tidyverse.org/help/#reprex) (this will also help you write a unit test, if needed).


### Pull request process

This requires kno

*   Fork the package and clone onto your computer. If you haven't done this before, we recommend using `usethis::create_from_github("subugoe/hoad", fork = TRUE)`.

*   Install all development dependences with `devtools::install_dev_deps()`, and then make sure the package passes R CMD check by running `devtools::check()`. 
    If R CMD check doesn't pass cleanly, it's a good idea to ask for help before continuing. 
*   Create a Git branch for your pull request (PR). We recommend using `usethis::pr_init("brief-description-of-change")`.

*   Make your changes, commit to git, and then create a PR by running `usethis::pr_push()`, and following the prompts in your browser.
    The title of your PR should briefly describe the change.
    The body of your PR should contain `Fixes #issue-number`.

*  For user-facing changes, add a bullet to the top of `NEWS.md` (i.e. just below the first header). Follow the style described in <https://style.tidyverse.org/news.html>.

### Code style

*   New code should follow the tidyverse [style guide](https://style.tidyverse.org). 
    You can use the [styler](https://CRAN.R-project.org/package=styler) package to apply these styles, but please don't restyle code that has nothing to do with your PR.  

*  We use [roxygen2](https://cran.r-project.org/package=roxygen2), with [Markdown syntax](https://cran.r-project.org/web/packages/roxygen2/vignettes/markdown.html), for documentation.  

*  We use [testthat](https://cran.r-project.org/package=testthat) for unit tests. 
   Contributions with test cases included are easier to accept.  


## Code of Conduct

Please note that the hoad project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this
project you agree to abide by its terms.
