FROM rstudio/r-base:3.6.3-bionic

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

# install pkg deps
COPY . .
RUN Rscript -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_deps(dependencies = TRUE, quiet = FALSE)'