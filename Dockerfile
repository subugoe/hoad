FROM rocker/rstudio:3.6.2

LABEL "name"="hoad"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="https://github.com/subugoe/hoad"
LABEL "homepage"="https://subugoe.github.io/hoad/"

COPY DESCRIPTION DESCRIPTION

# copy in cache
# if this is run outside of github actions, will just copy empty dir
COPY deps /usr/local/lib/R/site-library
# install system dependencies
RUN Rscript -e "options(warn = 2); install.packages('remotes')"
RUN Rscript -e "options(warn = 2); remotes::install_github('r-hub/sysreqs', ref='3860f2b512a9c3bd3db6791c2ff467a1158f4048')"
ENV RHUB_PLATFORM="linux-x86_64-debian-gcc"
RUN sysreqs=$(Rscript -e "cat(sysreqs::sysreq_commands('DESCRIPTION'))") && \
  eval "$sysreqs"

# install dependencies
RUN Rscript -e "options(warn = 2); remotes::install_deps(dependencies = TRUE)"