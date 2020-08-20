ARG MUGGLE_TAG=a7876ed9ad79909bcf8ff04d1d8c30503bdb8b0a
FROM subugoe/muggle-buildtime-onbuild:${MUGGLE_TAG} as buildtime
FROM subugoe/muggle-runtime-onbuild:${MUGGLE_TAG} as runtime
CMD shinycaas::az_webapp_shiny_opts(); hoad::runHOAD()
