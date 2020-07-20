#!/usr/bin/env bash
set -e

Rscript -e "hoad::runHOAD(shiny_args = list(port = 80, host = '0.0.0.0'))"
