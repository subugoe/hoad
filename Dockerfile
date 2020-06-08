# below block needs to be the same as in .github/workflows/main.yaml
# this freezes the r version
FROM rocker/rstudio:3.6.3-ubuntu18.04
# unfortunately this has to be updated by hand
ENV LIB_PATH="/usr/local/lib/R/site-library"

LABEL "name"="hoad"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="https://github.com/subugoe/hoad"
LABEL "homepage"="https://subugoe.github.io/hoad/"

COPY .Rprofile DESCRIPTION /hoad/

# copy in cache
# if this is run outside of github actions, will just copy empty dir
COPY .deps/ ${LIB_PATH}
WORKDIR "/hoad"
# install system dependencies
RUN Rscript -e "options(warn = 2); install.packages('remotes')"

# below block needs to be the same as in .github/workflows/main.yaml
RUN apt-get update
# TODO hack for missing time zone data base, bug in rocker?
RUN apt-get install -y tzdata
# hack-fix for https://github.com/r-hub/sysreqsdb/issues/77
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:cran/libgit2
# hack for missing sysdeps for ggalt as per https://github.com/hrbrmstr/ggalt/issues/22
RUN apt-get install -y libproj-dev

RUN Rscript -e "options(warn = 2); remotes::install_github('r-hub/sysreqs', ref='3860f2b512a9c3bd3db6791c2ff467a1158f4048')"
ENV RHUB_PLATFORM="linux-x86_64-ubuntu-gcc"
RUN sysreqs=$(Rscript -e "cat(sysreqs::sysreq_commands('DESCRIPTION'))") && \
  eval "$sysreqs"

# install dependencies
RUN Rscript -e "options(warn = 2); remotes::install_deps(dependencies = TRUE)"

COPY . /hoad/

# install package into container
RUN Rscript -e "remotes::install_local(upgrade = FALSE)"

EXPOSE 80
ENTRYPOINT ["Rscript", "-e", "hoad::runHOAD(shiny_args = list(port = 80, host = '0.0.0.0'))"]
