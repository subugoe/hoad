ARG MUGGLE_TAG=9acfa4d9633250bdb85de69a803d426ecb7a14a1
FROM subugoe/muggle-buildtime-onbuild:${MUGGLE_TAG} as buildtime
FROM subugoe/muggle-runtime-onbuild:${MUGGLE_TAG} as runtime
CMD shinycaas::az_webapp_shiny_opts(); hoad::runHOAD()
