FROM rocker/r-ver:3.6.1
LABEL maintainer="jjchern"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
 && apt-get install -y git-core \
	libxml2-dev \
	make \
	NULL
RUN ["install2.r", "-r 'https://cloud.r-project.org'", "labelled", "readxl", "forcats", "stringr", "dplyr", "purrr", "readr", "tidyr", "tibble", "ggplot2", "tidyverse", "testthat", "devtools", "usethis", "Rcpp", "lubridate", "lattice", "clisymbols", "prettyunits", "ps", "utf8", "assertthat", "zeallot", "rprojroot", "digest", "R6", "cellranger", "futile.options", "backports", "httr", "pillar", "rlang", "lazyeval", "rstudioapi", "callr", "desc", "munsell", "broom", "modelr", "pkgconfig", "pkgbuild", "tidyselect", "fansi", "crayon", "withr", "nlme", "jsonlite", "gtable", "formatR", "magrittr", "scales", "cli", "stringi", "fs", "remotes", "xml2", "futile.logger", "ellipsis", "fortunes", "vctrs", "generics", "lambda.r", "glue", "hms", "processx", "pkgload", "yaml", "colorspace", "sessioninfo", "rvest", "memoise", "haven"]
RUN ["installGithub.r", "tbradley1013/dundermifflin@8cf3e65"]
WORKDIR /payload/
CMD ["R"]
