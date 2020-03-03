FROM rstudio/r-base:3.6.3-bionic

LABEL "name"="hoad"
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
  libcurl4-openssl-dev

# set shell to Rscript to make syntax shorter
SHELL ["usr/bin/Rscript", "-e"]

# install pkg deps
COPY . .
RUN install.packages('remotes')
RUN remotes::install_deps(dependencies = TRUE, quiet = FALSE)

ONBUILD SHELL ["/bin/sh", "-c"]