ARG MUGGLE_TAG=9ee02c2d9b32cab07681288de9995dc3d4124e4d
FROM subugoe/muggle-buildtime-onbuild:${MUGGLE_TAG} as buildtime
FROM subugoe/muggle-runtime-onbuild:${MUGGLE_TAG} as runtime
CMD shinycaas::az_webapp_shiny_opts(); hoad::runHOAD()
