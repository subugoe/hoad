# below block needs to be the same as in .github/workflows/main.yaml
# this freezes the r version
FROM rstudio/r-base:4.0-bionic
# this freezes the package versions
ENV RSPM="https://packagemanager.rstudio.com/cran/__linux__/bionic/279"
# unfortunately this has to be updated by hand
ENV LIB_PATH="/opt/R/4.0.0/lib/R/library"

LABEL "name"="hoad"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="https://github.com/subugoe/hoad"
LABEL "homepage"="https://subugoe.github.io/hoad/"

COPY DESCRIPTION DESCRIPTION

# copy in cache
# if this is run outside of github actions, will just copy empty dir
COPY deps/ ${LIB_PATH}
# install system dependencies
RUN Rscript -e "options(warn = 2); install.packages('remotes', repos = Sys.getenv('RSPM'))"
RUN Rscript -e "options(warn = 2); remotes::install_github('r-hub/sysreqs', ref='3860f2b512a9c3bd3db6791c2ff467a1158f4048')"
ENV RHUB_PLATFORM="linux-x86_64-ubuntu-gcc"
RUN sysreqs=$(Rscript -e "cat(sysreqs::sysreq_commands('DESCRIPTION'))") && \
  eval "$sysreqs"

# install dependencies
RUN Rscript -e "options(warn = 2); remotes::install_deps(dependencies = TRUE, repos = Sys.getenv('RSPM'))"