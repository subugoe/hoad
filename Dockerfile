ARG MUGGLE_TAG=0.1.1-20210126
FROM subugoe/muggle-buildtime-onbuild:${MUGGLE_TAG} as buildtime
FROM subugoe/muggle-runtime-onbuild:${MUGGLE_TAG} as runtime
CMD shinycaas::shiny_opts_az(); hoad::runHOAD()
