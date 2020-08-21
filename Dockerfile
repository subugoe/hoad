ARG MUGGLE_TAG=latest
FROM subugoe/muggle-buildtime-onbuild:${MUGGLE_TAG} as buildtime
FROM subugoe/muggle-runtime-onbuild:${MUGGLE_TAG} as runtime
CMD shinycaas::az_webapp_shiny_opts(); hoad::runHOAD()
