FROM rocker/tidyverse:3.6.2

LABEL "name"="hoad-dev"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="https://github.com/subugoe/hybrid_oa_dashboard"
LABEL "homepage"="https://subugoe.github.io/hybrid_oa_dashboard/"

# install sysdeps
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  pkg-config \
  proj-bin \
  libxml2-dev \
  libssl-dev \
  libcurl4-openssl-dev \
  libproj-dev \
  libgdal-dev

# set shell to Rscript to make syntax shorter
SHELL ["/usr/local/bin/Rscript", "-e"]

# install pkg deps
COPY . .
RUN remotes::install_deps(dependencies = TRUE, quiet = FALSE)

ONBUILD SHELL ["/bin/sh", "-c"]